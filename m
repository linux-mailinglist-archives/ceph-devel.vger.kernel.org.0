Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6D74D47CC
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Mar 2022 14:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbiCJNNm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Mar 2022 08:13:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231617AbiCJNNl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Mar 2022 08:13:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72AA15FEB
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 05:12:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A642BB82225
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 13:12:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3132C340E8;
        Thu, 10 Mar 2022 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646917951;
        bh=hcaNkKZ4TVSnNMj5bY01loODw18R70DlYd4JnZLoVlo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=r1NHYw8SPQDn7Kf6a7h2csAOMfq00L4BC4isjQUnEpx7vmYBOGULs1qZtmzQBLDKE
         B5yjzv/Ejpla8IgnDAsdhsj6AWqm6XyHFz9SG/kupddyGvw95G90KdZhDCzQJGaZIM
         gc3ecDJlAe+vsPD+wVVgPZL0ktqn/AdPdWaXjcMWWgpsUjG2RD0ELn/P24jx7MJIGa
         IAsjFTUJQNMWNlrVD34Od3QED7wBREd9V6JP4SbVKhDOvKMzGJbLBuL8wF+uBjrh/O
         TjDElSQZuPRZ9FwoJJj+empC+YWGgUOCgzLIhFIZqD0v8XW0B/ntdzcZSqHz4TsH86
         eYYFTT1hjOvJw==
Message-ID: <83749d60be304a7e8caa14cba8efb2403e8b190f.camel@kernel.org>
Subject: Re: [PATCH V7] ceph: do not dencrypt the dentry name twice for
 readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Thu, 10 Mar 2022 08:12:29 -0500
In-Reply-To: <38417720-4c85-4a18-4877-d511122af249@redhat.com>
References: <20220309135914.95804-1-xiubli@redhat.com>
         <b0605e1e-5c54-d250-8e93-773638d36ab6@redhat.com>
         <b53ce2d4d085f94490e715253cf269a8d5dbdebf.camel@kernel.org>
         <fb1c96e4-22ed-98a2-0495-65c791ee83d9@redhat.com>
         <a498f8d751b2e08cfa3a273a428ca57099792780.camel@kernel.org>
         <38417720-4c85-4a18-4877-d511122af249@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-03-10 at 20:21 +0800, Xiubo Li wrote:
> On 3/10/22 7:21 PM, Jeff Layton wrote:
> > On Thu, 2022-03-10 at 18:54 +0800, Xiubo Li wrote:
> > > On 3/10/22 6:36 PM, Jeff Layton wrote:
> > > > On Thu, 2022-03-10 at 14:08 +0800, Xiubo Li wrote:
> > > > > On 3/9/22 9:59 PM, xiubli@redhat.com wrote:
> > > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > > 
> > > > > > For the readdir request the dentries will be pasred and dencrypted
> > > > > > in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
> > > > > > get the dentry name from the dentry cache instead of parsing and
> > > > > > dencrypting them again. This could improve performance.
> > > > > > 
> > > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > > ---
> > > > > > 
> > > > > > V7:
> > > > > > - Fix the xfstest generic/006 crash bug about the rde->dentry == NULL.
> > > > > > 
> > > > > > V6:
> > > > > > - Remove CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro and use the NAME_MAX
> > > > > >      instead, since we are limiting the max length of snapshot name to
> > > > > >      240, which is NAME_MAX - 2 * sizeof('_') - sizeof(<inode#>).
> > > > > > 
> > > > > > V5:
> > > > > > - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
> > > > > > - release the rde->dentry in destroy_reply_info
> > > > > > 
> > > > > > 
> > > > > > 
> > > > > >     fs/ceph/dir.c        | 56 ++++++++++++++++++++------------------------
> > > > > >     fs/ceph/inode.c      |  7 ++++++
> > > > > >     fs/ceph/mds_client.c |  1 +
> > > > > >     fs/ceph/mds_client.h |  1 +
> > > > > >     4 files changed, 34 insertions(+), 31 deletions(-)
> > > > > > 
> > > > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > > > index 6df2a91af236..2397c34e9173 100644
> > > > > > --- a/fs/ceph/dir.c
> > > > > > +++ b/fs/ceph/dir.c
> > > > > > @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > > >     	int err;
> > > > > >     	unsigned frag = -1;
> > > > > >     	struct ceph_mds_reply_info_parsed *rinfo;
> > > > > > -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
> > > > > > -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
> > > > > > +	char *dentry_name = NULL;
> > > > > >     
> > > > > >     	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
> > > > > >     	if (dfi->file_info.flags & CEPH_F_ATEND)
> > > > > > @@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > > >     		spin_unlock(&ci->i_ceph_lock);
> > > > > >     	}
> > > > > >     
> > > > > > -	err = ceph_fname_alloc_buffer(inode, &tname);
> > > > > > -	if (err < 0)
> > > > > > -		goto out;
> > > > > > -
> > > > > > -	err = ceph_fname_alloc_buffer(inode, &oname);
> > > > > > -	if (err < 0)
> > > > > > -		goto out;
> > > > > > -
> > > > > >     	/* proceed with a normal readdir */
> > > > > >     more:
> > > > > >     	/* do we have the correct frag content buffered? */
> > > > > > @@ -528,31 +519,36 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > > >     			}
> > > > > >     		}
> > > > > >     	}
> > > > > > +
> > > > > > +	dentry_name = kmalloc(NAME_MAX, GFP_KERNEL);
> > > > > > +	if (!dentry_name) {
> > > > > > +		err = -ENOMEM;
> > > > > > +		ceph_mdsc_put_request(dfi->last_readdir);
> > > > > > +		dfi->last_readdir = NULL;
> > > > > > +		goto out;
> > > > > > +	}
> > > > > > +
> > > > > >     	for (; i < rinfo->dir_nr; i++) {
> > > > > >     		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> > > > > > -		struct ceph_fname fname = { .dir	= inode,
> > > > > > -					    .name	= rde->name,
> > > > > > -					    .name_len	= rde->name_len,
> > > > > > -					    .ctext	= rde->altname,
> > > > > > -					    .ctext_len	= rde->altname_len };
> > > > > > -		u32 olen = oname.len;
> > > > > > -
> > > > > > -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> > > > > > -		if (err) {
> > > > > > -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> > > > > > -			       rde->name_len, rde->name, err);
> > > > > > -			goto out;
> > > > > > -		}
> > > > > > +		struct dentry *dn = rde->dentry;
> > > > > > +		int name_len;
> > > > > >     
> > > > > >     		BUG_ON(rde->offset < ctx->pos);
> > > > > >     		BUG_ON(!rde->inode.in);
> > > > > > +		BUG_ON(!rde->dentry);
> > > > > >     
> > > > > >     		ctx->pos = rde->offset;
> > > > > > -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
> > > > > > -		     i, rinfo->dir_nr, ctx->pos,
> > > > > > -		     rde->name_len, rde->name, &rde->inode.in);
> > > > > >     
> > > > > > -		if (!dir_emit(ctx, oname.name, oname.len,
> > > > > > +		spin_lock(&dn->d_lock);
> > > > > > +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
> > > > > > +		name_len = dn->d_name.len;
> > > > > > +		spin_unlock(&dn->d_lock);
> > > > > > +
> > > > > Hi Jeff,
> > > > > 
> > > > > BTW, does the dn->d_lock is must here ? From the code comments, the
> > > > > d_lock intends to protect the 'd_flag' and 'd_lockref.count'.
> > > > > 
> > > > > In ceph code I found some places are using the d_lock when accessing the
> > > > > d_name, some are not. And in none ceph code, they will almost never use
> > > > > the d_lock to protect the d_name.
> > > > > 
> > > > It's probably not needed. The d_name can only change if there are no
> > > > other outstanding references to the dentry.
> > > If so, the dentry_name = kmalloc() is not needed any more.
> > > 
> > > 
> > I take it back.
> > 
> > I think the d_lock is the only thing that protects this against a
> > concurrent rename. Have a look at __d_move, and (in particular) the call
> > to copy_name. The d_lock is what guards against that happening while
> > you're working with it here.
> > 
> > You might be able to get away without using it, but you'll need to
> > follow similar rules as RCU walk.
> > 
> > FWIW, the best source for this info is Neil Brown's writeup in
> > Documentation/filesystems/path_lookup.rst.
> 

That should have been Documentation/filesystems/path-lookup.rst


> IMO we can get rid of the 'd_lock' by:
> 
> char *dentry_name = READ_ONCE(dentry->d_name.name);
> 
> if (!dir_emit(ctx, dentry_name, strlen(dentry_name),....
> 
> Because both the swap_names() and copy_name() won't release the memory 
> of dentry->d_name.name.
> 
> But possible we will see a corrupted dentry name if it's doing the 
> copy_name() ?
> 

ceph already satisfies readdir out of the dcache in some cases. See
__dcache_readdir, which basically walks a list of dentry pointers
stashed in the pagecache and then calls dir_emit on each (without the
dentry->d_lock held!). That's a bit different though since we have some
assurance that things won't change in that case (it may still be racy
too -- not sure).

I don't think you have the same guarantees here. What might be best is
to either allocate (or declare on-stack) a NAME_MAX buffer, and copy
into that from the d_name while you hold the lock. Then drop the lock
and dir_emit.

I wonder if we're going about this the wrong way...

Once we've decrypted the names, we don't need the crypttext anymore at
all. Maybe it would be better to just decrypt the names in-place, or
copy back over the crypttext after decrypting? Then we might not even
need some of these changes in readdir at all.


> > > > > > +		dentry_name[name_len] = '\0';
> > > > > > +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
> > > > > > +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
> > > > > > +
> > > > > > +		if (!dir_emit(ctx, dentry_name, name_len,
> > > > > >     			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
> > > > > >     			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
> > > > > >     			/*
> > > > > > @@ -566,8 +562,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > > >     			goto out;
> > > > > >     		}
> > > > > >     
> > > > > > -		/* Reset the lengths to their original allocated vals */
> > > > > > -		oname.len = olen;
> > > > > >     		ctx->pos++;
> > > > > >     	}
> > > > > >     
> > > > > > @@ -625,8 +619,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > > >     	err = 0;
> > > > > >     	dout("readdir %p file %p done.\n", inode, file);
> > > > > >     out:
> > > > > > -	ceph_fname_free_buffer(inode, &tname);
> > > > > > -	ceph_fname_free_buffer(inode, &oname);
> > > > > > +	if (dentry_name)
> > > > > > +		kfree(dentry_name);
> > > > > >     	return err;
> > > > > >     }
> > > > > >     
> > > > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > > > index b573a0f33450..19e5275eae1c 100644
> > > > > > --- a/fs/ceph/inode.c
> > > > > > +++ b/fs/ceph/inode.c
> > > > > > @@ -1909,6 +1909,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> > > > > >     			goto out;
> > > > > >     		}
> > > > > >     
> > > > > > +		rde->dentry = NULL;
> > > > > >     		dname.name = oname.name;
> > > > > >     		dname.len = oname.len;
> > > > > >     		dname.hash = full_name_hash(parent, dname.name, dname.len);
> > > > > > @@ -1969,6 +1970,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> > > > > >     			goto retry_lookup;
> > > > > >     		}
> > > > > >     
> > > > > > +		/*
> > > > > > +		 * ceph_readdir will use the dentry to get the name
> > > > > > +		 * to avoid doing the dencrypt again there.
> > > > > > +		 */
> > > > > > +		rde->dentry = dget(dn);
> > > > > > +
> > > > > >     		/* inode */
> > > > > >     		if (d_really_is_positive(dn)) {
> > > > > >     			in = d_inode(dn);
> > > > > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > > > > index 8d704ddd7291..9e0a51ef1dfa 100644
> > > > > > --- a/fs/ceph/mds_client.c
> > > > > > +++ b/fs/ceph/mds_client.c
> > > > > > @@ -733,6 +733,7 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
> > > > > >     
> > > > > >     		kfree(rde->inode.fscrypt_auth);
> > > > > >     		kfree(rde->inode.fscrypt_file);
> > > > > > +		dput(rde->dentry);
> > > > > >     	}
> > > > > >     	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
> > > > > >     }
> > > > > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > > > > index 0dfe24f94567..663d7754d57d 100644
> > > > > > --- a/fs/ceph/mds_client.h
> > > > > > +++ b/fs/ceph/mds_client.h
> > > > > > @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
> > > > > >     };
> > > > > >     
> > > > > >     struct ceph_mds_reply_dir_entry {
> > > > > > +	struct dentry		      *dentry;
> > > > > >     	char                          *name;
> > > > > >     	u8			      *altname;
> > > > > >     	u32                           name_len;
> 

-- 
Jeff Layton <jlayton@kernel.org>
