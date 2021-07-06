Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944CF3BDD63
	for <lists+ceph-devel@lfdr.de>; Tue,  6 Jul 2021 20:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhGFSoQ (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 6 Jul 2021 14:44:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42171 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231556AbhGFSoP (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 6 Jul 2021 14:44:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625596896;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cPbl0M+tyTi2Qe97FM6FBTnTNsIOZdhzOJcwJCn5zzM=;
        b=Q15/8jfuvcOvy3Qu5FsLiy5uHsxden9x5CLC/pUjVo6PQV4hkCgwl4kHav5dMqswra9tUY
        OPG+EKqN4k2xYnDv2OeOEoH1I7UwkPchVaGjE6tAUR7SywpxUhSkINUyoNS7sj6I34xz8e
        pZ8mcjGnl9o7oZRdH+g91Hat54S82nY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-SrWOTHC_MQOv32eqYI2yZg-1; Tue, 06 Jul 2021 14:41:14 -0400
X-MC-Unique: SrWOTHC_MQOv32eqYI2yZg-1
Received: by mail-qk1-f199.google.com with SMTP id o189-20020a378cc60000b02903b2ccd94ea1so17313372qkd.19
        for <ceph-devel@vger.kernel.org>; Tue, 06 Jul 2021 11:41:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=cPbl0M+tyTi2Qe97FM6FBTnTNsIOZdhzOJcwJCn5zzM=;
        b=UUDte3p1eVHxj8o6fyjBH4i6p1RhZu1OxG1N+Cu/MkwR/G7xe4cdX+CdFoqOzLwdXi
         zZy+0VqRLawH/esQQPUoUlvCpJ16NU8xAKbKxzpk/M3eKDCJH1QcHv2tMXwLq4JdT/69
         kulwXtBZJ2c8HFhNbYH1WX7ke0iOpdKGhAr5IkKGxg9VrwRIHQzQn52x6bISKqd/2Xgs
         qxQPvqhqt9tqqkqZ6p+qhwQcz4BPCRnB2U/pkhXbluRQubtLi57oHDqQ0MeV84D8MAm/
         e+TdLu3ldprADemyvy6Y/5HU0xZGdJL9yhv9hwPR6Kv6ragKgcS6uh/CVnptq9RmK2zN
         6E2A==
X-Gm-Message-State: AOAM531tpG+GyKJ2z43jb/h+3cYQzpMmEmsA6fUKdAKvhcmZvBWlQSsj
        BQtysPfFRxemOGrjc52RsutIEUerPQz50Badf51c9029Di0/7DhZgwehRV7sZjfBpX1Rp9lZvhU
        mfhvsw1Po6fiHRLENMk9VGA==
X-Received: by 2002:a05:622a:1896:: with SMTP id v22mr18644118qtc.348.1625596874455;
        Tue, 06 Jul 2021 11:41:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxksn0s23aXU6+q1cB1kdk5TYs8uAImpCj7v6+oBwAzs0WciWT+r7v+onyEX9N12nS18pjHrg==
X-Received: by 2002:a05:622a:1896:: with SMTP id v22mr18644094qtc.348.1625596874234;
        Tue, 06 Jul 2021 11:41:14 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id y11sm7183175qkj.48.2021.07.06.11.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jul 2021 11:41:13 -0700 (PDT)
Message-ID: <fae403657994d7372cf7b17f75bc2a9a8ce4fb84.camel@redhat.com>
Subject: Re: [PATCH v2 1/4] ceph: new device mount syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>,
        Luis Henriques <lhenriques@suse.de>
Cc:     idryomov@gmail.com, Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Date:   Tue, 06 Jul 2021 14:41:13 -0400
In-Reply-To: <CACPzV1k6RYqp+tE0g2q4LLfwvXM6MYsC8w7RYaF81LETcjbWWw@mail.gmail.com>
References: <20210702064821.148063-1-vshankar@redhat.com>
         <20210702064821.148063-2-vshankar@redhat.com> <YN7smzFk20Oyhixi@suse.de>
         <CACPzV1k6RYqp+tE0g2q4LLfwvXM6MYsC8w7RYaF81LETcjbWWw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 2021-07-02 at 16:35 +0530, Venky Shankar wrote:
> On Fri, Jul 2, 2021 at 4:08 PM Luis Henriques <lhenriques@suse.de> wrote:
> > 
> > On Fri, Jul 02, 2021 at 12:18:18PM +0530, Venky Shankar wrote:
> > > Old mount device syntax (source) has the following problems:
> > > 
> > > - mounts to the same cluster but with different fsnames
> > >   and/or creds have identical device string which can
> > >   confuse xfstests.
> > > 
> > > - Userspace mount helper tool resolves monitor addresses
> > >   and fill in mon addrs automatically, but that means the
> > >   device shown in /proc/mounts is different than what was
> > >   used for mounting.
> > > 
> > > New device syntax is as follows:
> > > 
> > >   cephuser@fsid.mycephfs2=/path
> > > 
> > > Note, there is no "monitor address" in the device string.
> > > That gets passed in as mount option. This keeps the device
> > > string same when monitor addresses change (on remounts).
> > > 
> > > Also note that the userspace mount helper tool is backward
> > > compatible. I.e., the mount helper will fallback to using
> > > old syntax after trying to mount with the new syntax.
> > > 
> > > Signed-off-by: Venky Shankar <vshankar@redhat.com>
> > > ---
> > >  fs/ceph/super.c | 122 ++++++++++++++++++++++++++++++++++++++++++++----
> > >  fs/ceph/super.h |   3 ++
> > >  2 files changed, 115 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> > > index 9b1b7f4cfdd4..0b324e43c9f4 100644
> > > --- a/fs/ceph/super.c
> > > +++ b/fs/ceph/super.c
> > > @@ -145,6 +145,7 @@ enum {
> > >       Opt_mds_namespace,
> > >       Opt_recover_session,
> > >       Opt_source,
> > > +     Opt_mon_addr,
> > >       /* string args above */
> > >       Opt_dirstat,
> > >       Opt_rbytes,
> > > @@ -196,6 +197,7 @@ static const struct fs_parameter_spec ceph_mount_parameters[] = {
> > >       fsparam_u32     ("rsize",                       Opt_rsize),
> > >       fsparam_string  ("snapdirname",                 Opt_snapdirname),
> > >       fsparam_string  ("source",                      Opt_source),
> > > +     fsparam_string  ("mon_addr",                    Opt_mon_addr),
> > >       fsparam_u32     ("wsize",                       Opt_wsize),
> > >       fsparam_flag_no ("wsync",                       Opt_wsync),
> > >       {}
> > > @@ -226,10 +228,70 @@ static void canonicalize_path(char *path)
> > >       path[j] = '\0';
> > >  }
> > > 
> > > +static int ceph_parse_old_source(const char *dev_name, const char *dev_name_end,
> > > +                              struct fs_context *fc)
> > > +{
> > > +     int r;
> > > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > > +
> > > +     if (*dev_name_end != ':')
> > > +             return invalfc(fc, "separator ':' missing in source");
> > > +
> > > +     r = ceph_parse_mon_ips(dev_name, dev_name_end - dev_name,
> > > +                            pctx->copts, fc->log.log);
> > > +     if (r)
> > > +             return r;
> > > +
> > > +     fsopt->new_dev_syntax = false;
> > > +     return 0;
> > > +}
> > > +
> > > +static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
> > > +                              struct fs_context *fc)
> > > +{
> > > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > > +     char *fsid_start, *fs_name_start;
> > > +
> > > +     if (*dev_name_end != '=') {
> > > +             dout("separator '=' missing in source");
> > > +             return -EINVAL;
> > > +     }
> > > +
> > > +     fsid_start = strchr(dev_name, '@');
> > > +     if (!fsid_start)
> > > +             return invalfc(fc, "missing cluster fsid");
> > > +     ++fsid_start; /* start of cluster fsid */
> > > +
> > > +     fs_name_start = strchr(fsid_start, '.');
> > > +     if (!fs_name_start)
> > > +             return invalfc(fc, "missing file system name");
> > > +
> > > +     ++fs_name_start; /* start of file system name */
> > > +     fsopt->mds_namespace = kstrndup(fs_name_start,
> > > +                                     dev_name_end - fs_name_start, GFP_KERNEL);
> > > +     if (!fsopt->mds_namespace)
> > > +             return -ENOMEM;
> > > +     dout("file system (mds namespace) '%s'\n", fsopt->mds_namespace);
> > > +
> > > +     fsopt->new_dev_syntax = true;
> > > +     return 0;
> > > +}
> > > +
> > >  /*
> > > - * Parse the source parameter.  Distinguish the server list from the path.
> > > + * Parse the source parameter for new device format. Distinguish the device
> > > + * spec from the path. Try parsing new device format and fallback to old
> > > + * format if needed.
> > >   *
> > > - * The source will look like:
> > > + * New device syntax will looks like:
> > > + *     <device_spec>=/<path>
> > > + * where
> > > + *     <device_spec> is name@fsid.fsname
> > > + *     <path> is optional, but if present must begin with '/'
> > > + * (monitor addresses are passed via mount option)
> > > + *
> > > + * Old device syntax is:
> > >   *     <server_spec>[,<server_spec>...]:[<path>]
> > >   * where
> > >   *     <server_spec> is <ip>[:<port>]
> > > @@ -262,22 +324,48 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
> > >               dev_name_end = dev_name + strlen(dev_name);
> > >       }
> > > 
> > > -     dev_name_end--;         /* back up to ':' separator */
> > > -     if (dev_name_end < dev_name || *dev_name_end != ':')
> > > -             return invalfc(fc, "No path or : separator in source");
> > > +     dev_name_end--;         /* back up to separator */
> > > +     if (dev_name_end < dev_name)
> > > +             return invalfc(fc, "path missing in source");
> > > 
> > >       dout("device name '%.*s'\n", (int)(dev_name_end - dev_name), dev_name);
> > >       if (fsopt->server_path)
> > >               dout("server path '%s'\n", fsopt->server_path);
> > > 
> > > -     ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
> > > -                              pctx->copts, fc->log.log);
> > > +     dout("trying new device syntax");
> > > +     ret = ceph_parse_new_source(dev_name, dev_name_end, fc);
> > > +     if (ret == 0)
> > > +             goto done;
> > > +
> > > +     dout("trying old device syntax");
> > > +     ret = ceph_parse_old_source(dev_name, dev_name_end, fc);
> > >       if (ret)
> > > -             return ret;
> > > +             goto out;
> > 
> > Do we really need this goto?  My (personal) preference would be to drop
> > this one and simply return.   And maybe it's even possible to drop the
> > previous 'goto done' too.
> 
> Sure. Just a preference I had.
> 
> > 
> > > + done:
> > >       fc->source = param->string;
> > >       param->string = NULL;
> > > -     return 0;
> > > + out:
> > > +     return ret;
> > > +}
> > > +
> > > +static int ceph_parse_mon_addr(struct fs_parameter *param,
> > > +                            struct fs_context *fc)
> > > +{
> > > +     int r;
> > > +     struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > > +
> > > +     kfree(fsopt->mon_addr);
> > > +     fsopt->mon_addr = param->string;
> > > +     param->string = NULL;
> > > +
> > > +     strreplace(fsopt->mon_addr, '/', ',');
> > > +     r = ceph_parse_mon_ips(fsopt->mon_addr, strlen(fsopt->mon_addr),
> > > +                            pctx->copts, fc->log.log);
> > > +        // since its used in ceph_show_options()
> > 
> > (nit: use c-style comments...? yeah, again personal preference :-)
> > 
> > > +     strreplace(fsopt->mon_addr, ',', '/');
> > 
> > This is ugly.  Have you considered modifying ceph_parse_mon_ips() (and
> > ceph_parse_ips()) to receive a delimiter as a parameter?''
> 
> I did. However, for most cases (all possibly), "," is the addr
> delimiter. So, I didn't take the approach to make these helpers really
> generic for parsing addrs.
> 

Yeah, I'm not a fan of this either. Why not just add an extra char
argument to to ceph_parse_mon_ips and use that to pass in a delimiter
char? Looks like you'll have to plumb it through a couple of functions
but that seems doable.

> > 
> > > +     return r;
> > >  }
> > > 
> > >  static int ceph_parse_mount_param(struct fs_context *fc,
> > > @@ -322,6 +410,8 @@ static int ceph_parse_mount_param(struct fs_context *fc,
> > >               if (fc->source)
> > >                       return invalfc(fc, "Multiple sources specified");
> > >               return ceph_parse_source(param, fc);
> > > +     case Opt_mon_addr:
> > > +             return ceph_parse_mon_addr(param, fc);
> > >       case Opt_wsize:
> > >               if (result.uint_32 < PAGE_SIZE ||
> > >                   result.uint_32 > CEPH_MAX_WRITE_SIZE)
> > > @@ -473,6 +563,7 @@ static void destroy_mount_options(struct ceph_mount_options *args)
> > >       kfree(args->mds_namespace);
> > >       kfree(args->server_path);
> > >       kfree(args->fscache_uniq);
> > > +     kfree(args->mon_addr);
> > >       kfree(args);
> > >  }
> > > 
> > > @@ -516,6 +607,10 @@ static int compare_mount_options(struct ceph_mount_options *new_fsopt,
> > >       if (ret)
> > >               return ret;
> > > 
> > > +     ret = strcmp_null(fsopt1->mon_addr, fsopt2->mon_addr);
> > > +     if (ret)
> > > +             return ret;
> > > +
> > >       return ceph_compare_options(new_opt, fsc->client);
> > >  }
> > > 
> > > @@ -571,9 +666,13 @@ static int ceph_show_options(struct seq_file *m, struct dentry *root)
> > >       if ((fsopt->flags & CEPH_MOUNT_OPT_NOCOPYFROM) == 0)
> > >               seq_puts(m, ",copyfrom");
> > > 
> > > -     if (fsopt->mds_namespace)
> > > +     /* dump mds_namespace when old device syntax is in use */
> > > +     if (fsopt->mds_namespace && !fsopt->new_dev_syntax)
> > >               seq_show_option(m, "mds_namespace", fsopt->mds_namespace);
> > 
> > I haven't really tested it, but... what happens if we set mds_namespace
> > *and* we're using the new syntax?  Or, in another words, what should
> > happen?

Probably best to just throw an error at mount time if they don't match.

> 
> Depends on the order of token parsing in ceph_parse_mount_param()
> which mds_namespace gets used.
> 
> (however, that means ceph_parse_new_source() should additionally
> kfree(fsopt->mds_namespace)).
> 
> 
> > Cheers,
> > --
> > Luís
> > 
> > > 
> > > +     if (fsopt->mon_addr)
> > > +             seq_printf(m, ",mon_addr=%s", fsopt->mon_addr);
> > > +
> > >       if (fsopt->flags & CEPH_MOUNT_OPT_CLEANRECOVER)
> > >               seq_show_option(m, "recover_session", "clean");
> > > 
> > > @@ -1048,6 +1147,7 @@ static int ceph_setup_bdi(struct super_block *sb, struct ceph_fs_client *fsc)
> > >  static int ceph_get_tree(struct fs_context *fc)
> > >  {
> > >       struct ceph_parse_opts_ctx *pctx = fc->fs_private;
> > > +     struct ceph_mount_options *fsopt = pctx->opts;
> > >       struct super_block *sb;
> > >       struct ceph_fs_client *fsc;
> > >       struct dentry *res;
> > > @@ -1059,6 +1159,8 @@ static int ceph_get_tree(struct fs_context *fc)
> > > 
> > >       if (!fc->source)
> > >               return invalfc(fc, "No source");
> > > +     if (fsopt->new_dev_syntax && !fsopt->mon_addr)
> > > +             return invalfc(fc, "No monitor address");
> > > 
> > >       /* create client (which we may/may not use) */
> > >       fsc = create_fs_client(pctx->opts, pctx->copts);
> > > diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> > > index c48bb30c8d70..8f71184b7c85 100644
> > > --- a/fs/ceph/super.h
> > > +++ b/fs/ceph/super.h
> > > @@ -87,6 +87,8 @@ struct ceph_mount_options {
> > >       unsigned int max_readdir;       /* max readdir result (entries) */
> > >       unsigned int max_readdir_bytes; /* max readdir result (bytes) */
> > > 
> > > +     bool new_dev_syntax;
> > > +
> > >       /*
> > >        * everything above this point can be memcmp'd; everything below
> > >        * is handled in compare_mount_options()
> > > @@ -96,6 +98,7 @@ struct ceph_mount_options {
> > >       char *mds_namespace;  /* default NULL */
> > >       char *server_path;    /* default NULL (means "/") */
> > >       char *fscache_uniq;   /* default NULL */
> > > +     char *mon_addr;
> > >  };
> > > 
> > >  struct ceph_fs_client {
> > > --
> > > 2.27.0
> > > 
> > 
> 
> 

-- 
Jeff Layton <jlayton@redhat.com>

