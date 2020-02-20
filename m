Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA1F165CD2
	for <lists+ceph-devel@lfdr.de>; Thu, 20 Feb 2020 12:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgBTLcT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 20 Feb 2020 06:32:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgBTLcT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 20 Feb 2020 06:32:19 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 76AA02071E;
        Thu, 20 Feb 2020 11:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582198338;
        bh=iXC4Qc8CTYGLXwKn3Nf77tNRxuWl4tTa7ewzlCyBLlA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OcQroaEKogClHlBLzdUyGopseo4lK2uAe4S5qPYmD9iQ9g02ptNF9fkT2tPtruP8r
         Dmn2MdgOe/1p8Z+bBwGR3SzNjEWyo2BjoBmKtV3hx4aNNB6Z5jlkNfDgudWMdmd+dL
         GTTdRSfHVeg70Yf749O95Eq8eZ+ZiG8HqqxQCN2c=
Message-ID: <0e760845e2d98057f7cac0b2a841cf294e555962.camel@kernel.org>
Subject: Re: [PATCH v5 07/12] ceph: perform asynchronous unlink if we have
 sufficient caps
From:   Jeff Layton <jlayton@kernel.org>
To:     "Yan, Zheng" <ukernel@gmail.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>,
        Zheng Yan <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Xiubo Li <xiubli@redhat.com>
Date:   Thu, 20 Feb 2020 06:32:16 -0500
In-Reply-To: <CAAM7YAnLELDoaWdO38Jez_HxiuC6mQhUgBJHspgkFYzVD7fnNQ@mail.gmail.com>
References: <20200219132526.17590-1-jlayton@kernel.org>
         <20200219132526.17590-8-jlayton@kernel.org>
         <CAAM7YAnLELDoaWdO38Jez_HxiuC6mQhUgBJHspgkFYzVD7fnNQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2020-02-20 at 14:44 +0800, Yan, Zheng wrote:
> On Wed, Feb 19, 2020 at 9:27 PM Jeff Layton <jlayton@kernel.org> wrote:
> > The MDS is getting a new lock-caching facility that will allow it
> > to cache the necessary locks to allow asynchronous directory operations.
> > Since the CEPH_CAP_FILE_* caps are currently unused on directories,
> > we can repurpose those bits for this purpose.
> > 
> > When performing an unlink, if we have Fx on the parent directory,
> > and CEPH_CAP_DIR_UNLINK (aka Fr), and we know that the dentry being
> > removed is the primary link, then then we can fire off an unlink
> > request immediately and don't need to wait on reply before returning.
> > 
> > In that situation, just fix up the dcache and link count and return
> > immediately after issuing the call to the MDS. This does mean that we
> > need to hold an extra reference to the inode being unlinked, and extra
> > references to the caps to avoid races. Those references are put and
> > error handling is done in the r_callback routine.
> > 
> > If the operation ends up failing, then set a writeback error on the
> > directory inode, and the inode itself that can be fetched later by
> > an fsync on the dir.
> > 
> > The behavior of dir caps is slightly different from caps on normal
> > files. Because these are just considered an optimization, if the
> > session is reconnected, we will not automatically reclaim them. They
> > are instead considered lost until we do another synchronous op in the
> > parent directory.
> > 
> > Async dirops are enabled via the "nowsync" mount option, which is
> > patterned after the xfs "wsync" mount option. For now, the default
> > is "wsync", but eventually we may flip that.
> > 
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/dir.c   | 103 ++++++++++++++++++++++++++++++++++++++++++++++--
> >  fs/ceph/super.c |  20 ++++++++++
> >  fs/ceph/super.h |   5 ++-
> >  3 files changed, 123 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 5b83bda57056..37ab09d223fc 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -1036,6 +1036,73 @@ static int ceph_link(struct dentry *old_dentry, struct inode *dir,
> >         return err;
> >  }
> > 
> > +static void ceph_async_unlink_cb(struct ceph_mds_client *mdsc,
> > +                                struct ceph_mds_request *req)
> > +{
> > +       int result = req->r_err ? req->r_err :
> > +                       le32_to_cpu(req->r_reply_info.head->result);
> > +
> > +       /* If op failed, mark everyone involved for errors */
> > +       if (result) {
> 
> I think this function will get called for -EJUKEBOX case.
> 

Good catch. I'll have another look at how to handle this better.

> 
> > +               int pathlen;
> > +               u64 base;
> > +               char *path = ceph_mdsc_build_path(req->r_dentry, &pathlen,
> > +                                                 &base, 0);
> > +
> > +               /* mark error on parent + clear complete */
> > +               mapping_set_error(req->r_parent->i_mapping, result);
> > +               ceph_dir_clear_complete(req->r_parent);
> > +
> > +               /* drop the dentry -- we don't know its status */
> > +               if (!d_unhashed(req->r_dentry))
> > +                       d_drop(req->r_dentry);
> > +
> > +               /* mark inode itself for an error (since metadata is bogus) */
> > +               mapping_set_error(req->r_old_inode->i_mapping, result);
> > +
> > +               pr_warn("ceph: async unlink failure path=(%llx)%s result=%d!\n",
> > +                       base, IS_ERR(path) ? "<<bad>>" : path, result);
> > +               ceph_mdsc_free_path(path, pathlen);
> > +       }
> > +       iput(req->r_old_inode);
> > +}
> > +
> > +static int get_caps_for_async_unlink(struct inode *dir, struct dentry *dentry)
> > +{
> > +       struct ceph_inode_info *ci = ceph_inode(dir);
> > +       struct ceph_dentry_info *di;
> > +       int got = 0, want = CEPH_CAP_FILE_EXCL | CEPH_CAP_DIR_UNLINK;
> > +
> > +       spin_lock(&ci->i_ceph_lock);
> > +       if ((__ceph_caps_issued(ci, NULL) & want) == want) {
> > +               ceph_take_cap_refs(ci, want, false);
> > +               got = want;
> > +       }
> > +       spin_unlock(&ci->i_ceph_lock);
> > +
> > +       /* If we didn't get anything, return 0 */
> > +       if (!got)
> > +               return 0;
> > +
> > +        spin_lock(&dentry->d_lock);
> > +        di = ceph_dentry(dentry);
> > +       /*
> > +        * - We are holding Fx, which implies Fs caps.
> > +        * - Only support async unlink for primary linkage
> > +        */
> > +       if (atomic_read(&ci->i_shared_gen) != di->lease_shared_gen ||
> > +           !(di->flags & CEPH_DENTRY_PRIMARY_LINK))
> > +               want = 0;
> > +        spin_unlock(&dentry->d_lock);
> > +
> > +       /* Do we still want what we've got? */
> > +       if (want == got)
> > +               return got;
> > +
> > +       ceph_put_cap_refs(ci, got);
> > +       return 0;
> > +}
> > +
> >  /*
> >   * rmdir and unlink are differ only by the metadata op code
> >   */
> > @@ -1045,6 +1112,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
> >         struct ceph_mds_client *mdsc = fsc->mdsc;
> >         struct inode *inode = d_inode(dentry);
> >         struct ceph_mds_request *req;
> > +       bool try_async = ceph_test_mount_opt(fsc, ASYNC_DIROPS);
> >         int err = -EROFS;
> >         int op;
> > 
> > @@ -1059,6 +1127,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
> >                         CEPH_MDS_OP_RMDIR : CEPH_MDS_OP_UNLINK;
> >         } else
> >                 goto out;
> > +retry:
> >         req = ceph_mdsc_create_request(mdsc, op, USE_AUTH_MDS);
> >         if (IS_ERR(req)) {
> >                 err = PTR_ERR(req);
> > @@ -1067,13 +1136,39 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
> >         req->r_dentry = dget(dentry);
> >         req->r_num_caps = 2;
> >         req->r_parent = dir;
> > -       set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> >         req->r_dentry_drop = CEPH_CAP_FILE_SHARED;
> >         req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
> >         req->r_inode_drop = ceph_drop_caps_for_unlink(inode);
> > -       err = ceph_mdsc_do_request(mdsc, dir, req);
> > -       if (!err && !req->r_reply_info.head->is_dentry)
> > -               d_delete(dentry);
> > +
> > +       if (try_async && op == CEPH_MDS_OP_UNLINK &&
> > +           (req->r_dir_caps = get_caps_for_async_unlink(dir, dentry))) {
> > +               dout("async unlink on %lu/%.*s caps=%s", dir->i_ino,
> > +                    dentry->d_name.len, dentry->d_name.name,
> > +                    ceph_cap_string(req->r_dir_caps));
> > +               set_bit(CEPH_MDS_R_ASYNC, &req->r_req_flags);
> > +               req->r_callback = ceph_async_unlink_cb;
> > +               req->r_old_inode = d_inode(dentry);
> > +               ihold(req->r_old_inode);
> > +               err = ceph_mdsc_submit_request(mdsc, dir, req);
> > +               if (!err) {
> > +                       /*
> > +                        * We have enough caps, so we assume that the unlink
> > +                        * will succeed. Fix up the target inode and dcache.
> > +                        */
> > +                       drop_nlink(inode);
> > +                       d_delete(dentry);
> > +               } else if (err == -EJUKEBOX) {
> > +                       try_async = false;
> > +                       ceph_mdsc_put_request(req);
> > +                       goto retry;
> > +               }
> > +       } else {
> > +               set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
> > +               err = ceph_mdsc_do_request(mdsc, dir, req);
> > +               if (!err && !req->r_reply_info.head->is_dentry)
> > +                       d_delete(dentry);
> > +       }
> > +
> >         ceph_mdsc_put_request(req);
> >  out:
> >         return err;
> > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > index b1329cd5388a..c9784eb1159a 100644
> > --- a/fs/ceph/super.c
> > +++ b/fs/ceph/super.c
> > @@ -155,6 +155,7 @@ enum {
> >         Opt_acl,
> >         Opt_quotadf,
> >         Opt_copyfrom,
> > +       Opt_wsync,
> >  };
> > 
> >  enum ceph_recover_session_mode {
> > @@ -194,6 +195,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
> >         fsparam_string  ("snapdirname",                 Opt_snapdirname),
> >         fsparam_string  ("source",                      Opt_source),
> >         fsparam_u32     ("wsize",                       Opt_wsize),
> > +       fsparam_flag_no ("wsync",                       Opt_wsync),
> >         {}
> >  };
> > 
> > @@ -444,6 +446,12 @@ static int ceph_parse_mount_param(struct fs_context *fc,
> >                         fc->sb_flags &= ~SB_POSIXACL;
> >                 }
> >                 break;
> > +       case Opt_wsync:
> > +               if (!result.negated)
> > +                       fsopt->flags &= ~CEPH_MOUNT_OPT_ASYNC_DIROPS;
> > +               else
> > +                       fsopt->flags |= CEPH_MOUNT_OPT_ASYNC_DIROPS;
> > +               break;
> >         default:
> >                 BUG();
> >         }
> > @@ -567,6 +575,9 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> >         if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> >                 seq_show_option(m, "recover_session", "clean");
> > 
> > +       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > +               seq_puts(m, ",nowsync");
> > +
> >         if (fsopt->wsize != CEPH_MAX_WRITE_SIZE)
> >                 seq_printf(m, ",wsize=%u", fsopt->wsize);
> >         if (fsopt->rsize != CEPH_MAX_READ_SIZE)
> > @@ -1115,6 +1126,15 @@ static void ceph_free_fc(struct fs_context *fc)
> > 
> >  static int ceph_reconfigure_fc(struct fs_context *fc)
> >  {
> > +       struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > +       struct ceph_mount_options *fsopt = pctx->opts;
> > +       struct ceph_fs_client *fsc = ceph_sb_to_client(fc->root->d_sb);
> > +
> > +       if (fsopt->flags & CEPH_MOUNT_OPT_ASYNC_DIROPS)
> > +               ceph_set_mount_opt(fsc, ASYNC_DIROPS);
> > +       else
> > +               ceph_clear_mount_opt(fsc, ASYNC_DIROPS);
> > +
> >         sync_filesystem(fc->root->d_sb);
> >         return 0;
> >  }
> > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > index 2393803c38de..1b4996efc111 100644
> > --- a/fs/ceph/super.h
> > +++ b/fs/ceph/super.h
> > @@ -43,13 +43,16 @@
> >  #define CEPH_MOUNT_OPT_MOUNTWAIT       (1<<12) /* mount waits if no mds is up */
> >  #define CEPH_MOUNT_OPT_NOQUOTADF       (1<<13) /* no root dir quota in statfs */
> >  #define CEPH_MOUNT_OPT_NOCOPYFROM      (1<<14) /* don't use RADOS 'copy-from' op */
> > +#define CEPH_MOUNT_OPT_ASYNC_DIROPS    (1<<15) /* allow async directory ops */
> > 
> >  #define CEPH_MOUNT_OPT_DEFAULT                 \
> >         (CEPH_MOUNT_OPT_DCACHE |                \
> >          CEPH_MOUNT_OPT_NOCOPYFROM)
> > 
> >  #define ceph_set_mount_opt(fsc, opt) \
> > -       (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt;
> > +       (fsc)->mount_options->flags |= CEPH_MOUNT_OPT_##opt
> > +#define ceph_clear_mount_opt(fsc, opt) \
> > +       (fsc)->mount_options->flags &= ~CEPH_MOUNT_OPT_##opt
> >  #define ceph_test_mount_opt(fsc, opt) \
> >         (!!((fsc)->mount_options->flags & CEPH_MOUNT_OPT_##opt))
> > 
> > --
> > 2.24.1
> > 

-- 
Jeff Layton <jlayton@kernel.org>

