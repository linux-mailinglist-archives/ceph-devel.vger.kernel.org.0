Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A04C8E0F
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 15:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiCAOoD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 09:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232465AbiCAOoC (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 09:44:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87CD3220DE
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 06:43:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A83161592
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 14:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF931C340EE;
        Tue,  1 Mar 2022 14:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646145800;
        bh=QRuOcMOQrDg3MLrCUwzXGCuvsWSgLuZfow/YMRmtGxk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=a8HqNc6Hc/5XoIDTNghe4+7f9pCU40+YNhUypSYOJj9duGyIZ9fGhPfkhxM0LcQUb
         h7XKwCsus9KHtB1wJFOWs8FkqPZnwXMyBhUeUZ2vOoE3DUhFjZGY3cOfXoI/b+Ks06
         V6UHvsp3sbzK1hFSfwnEOie4+xQXAefAknWFWG94f/1RQEnc6kpmwWomkgd/gv21C/
         YD5t17rd07GGX6yxFMQF/brG7k32fjW6nETODobfOXTw9mhSq4Bwb4GqSS3Y3rfTRa
         /2fnBjBGtssAQr6gB89rykEVsCpqmxQrfkGCEGDJM07YgzI7JnU1fZnhib4GplZXal
         6oOF2WsLGZpiw==
Message-ID: <37a43721dc73698a201c5306a96c88f5f8252a92.camel@kernel.org>
Subject: Re: [PATCH v2 3/7] ceph: do not dencrypt the dentry name twice for
 readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Tue, 01 Mar 2022 09:43:18 -0500
In-Reply-To: <55ebd844-0210-8c2f-0733-481cb864674d@redhat.com>
References: <20220301113015.498041-1-xiubli@redhat.com>
         <20220301113015.498041-4-xiubli@redhat.com>
         <3ce7d8ee236f25ceb139caa8b4f31d8628f47abc.camel@kernel.org>
         <a81395dd-e6e2-8dd5-93ca-e45ac746f16e@redhat.com>
         <3c3f31d1b1ca013de3f7bce3a69dc036f2c609f2.camel@kernel.org>
         <55ebd844-0210-8c2f-0733-481cb864674d@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-01 at 22:33 +0800, Xiubo Li wrote:
> On 3/1/22 10:18 PM, Jeff Layton wrote:
> > On Tue, 2022-03-01 at 22:05 +0800, Xiubo Li wrote:
> > > On 3/1/22 9:31 PM, Jeff Layton wrote:
> > > > On Tue, 2022-03-01 at 19:30 +0800, xiubli@redhat.com wrote:
> > > > > From: Xiubo Li <xiubli@redhat.com>
> > > > > 
> > > > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > > > ---
> > > > >    fs/ceph/dir.c        | 66 +++++++++++++++++++++-----------------------
> > > > >    fs/ceph/inode.c      | 15 ++++++++++
> > > > >    fs/ceph/mds_client.h |  1 +
> > > > >    3 files changed, 47 insertions(+), 35 deletions(-)
> > > > > 
> > > > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > > > index 6be0c1f793c2..e3917b4426e8 100644
> > > > > --- a/fs/ceph/dir.c
> > > > > +++ b/fs/ceph/dir.c
> > > > > @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > >    	int err;
> > > > >    	unsigned frag = -1;
> > > > >    	struct ceph_mds_reply_info_parsed *rinfo;
> > > > > -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
> > > > > -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
> > > > > +	char *dentry_name = NULL;
> > > > >    
> > > > >    	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
> > > > >    	if (dfi->file_info.flags & CEPH_F_ATEND)
> > > > > @@ -345,10 +344,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > >    		ctx->pos = 2;
> > > > >    	}
> > > > >    
> > > > > -	err = fscrypt_prepare_readdir(inode);
> > > > > -	if (err)
> > > > > -		goto out;
> > > > > -
> > > > Why are you removing this? This is what ensures that the key is loaded
> > > > if we're going to need it.
> > > Since the dentry names are already decrypted in
> > > ceph_readdir_prepopulate(), and this patch is trying to avoid do the
> > > same thing again here after that.
> > > 
> > > Because in ceph_readdir() this isn't needed any more. And in other
> > > places such as build path it will do it when needed.
> > > 
> > > > >    	spin_lock(&ci->i_ceph_lock);
> > > > >    	/* request Fx cap. if have Fx, we don't need to release Fs cap
> > > > >    	 * for later create/unlink. */
> > > > > @@ -369,14 +364,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > >    		spin_unlock(&ci->i_ceph_lock);
> > > > >    	}
> > > > >    
> > > > > -	err = ceph_fname_alloc_buffer(inode, &tname);
> > > > > -	if (err < 0)
> > > > > -		goto out;
> > > > > -
> > > > > -	err = ceph_fname_alloc_buffer(inode, &oname);
> > > > > -	if (err < 0)
> > > > > -		goto out;
> > > > > -
> > > > >    	/* proceed with a normal readdir */
> > > > >    more:
> > > > >    	/* do we have the correct frag content buffered? */
> > > > > @@ -525,40 +512,49 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > >    			}
> > > > >    		}
> > > > >    	}
> > > > > +
> > > > > +	dentry_name = kmalloc(280, GFP_KERNEL);
> > > > > +	if (!dentry_name) {
> > > > > +		err = -ENOMEM;
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > Woah, what's up with the bare "280" here?
> > > The long snap name in format of "_${ENCRYPTED-SNAP-NAME}_${INO}", the
> > > max length will be 1 +256 + 16.
> > > 
> > Ok. Best to make a named constant definition for this then. Bare numbers
> > in an allocation like this make it hard to understand what's going on.
> > 
> Sure.
> 
> So will this patch still makes sense ?
> 
>  From my test with thousands of dentries this could save a lot of time.
> 
> 

Yeah, I think so.

It probably would have made more sense if you had described in the
commit message how we end up decrypting the names twice, and how this
patch addresses that.

> > > > 
> > > > >    	for (; i < rinfo->dir_nr; i++) {
> > > > >    		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> > > > > -		struct ceph_fname fname = { .dir	= inode,
> > > > > -					    .name	= rde->name,
> > > > > -					    .name_len	= rde->name_len,
> > > > > -					    .ctext	= rde->altname,
> > > > > -					    .ctext_len	= rde->altname_len };
> > > > > -		u32 olen = oname.len;
> > > > > -
> > > > > -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> > > > > -		if (err) {
> > > > > -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> > > > > -			       rde->name_len, rde->name, err);
> > > > > -			goto out;
> > > > > -		}
> > > > I may be missing something, but if you rip this out, where does the
> > > > decryption happen?
> > > In ceph_readdir_prepopulate(), and it will set the rde->dentry, and here
> > > we can get the name from the dentry directly instead of decrypt it again.
> > > 
> > > > > +		struct dentry *dn = rde->dentry;
> > > > > +		int name_len;
> > > > >    
> > > > >    		BUG_ON(rde->offset < ctx->pos);
> > > > >    		BUG_ON(!rde->inode.in);
> > > > > +		BUG_ON(!rde->dentry);
> > > > >    
> > > > >    		ctx->pos = rde->offset;
> > > > > -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
> > > > > -		     i, rinfo->dir_nr, ctx->pos,
> > > > > -		     rde->name_len, rde->name, &rde->inode.in);
> > > > >    
> > > > > -		if (!dir_emit(ctx, oname.name, oname.len,
> > > > > +		spin_lock(&dn->d_lock);
> > > > > +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
> > > > > +		name_len = dn->d_name.len;
> > > > > +		spin_unlock(&dn->d_lock);
> > > > > +
> > > > > +		dentry_name[name_len] = '\0';
> > > > > +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
> > > > > +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
> > > > > +
> > > > > +		dput(dn);
> > > > > +		rde->dentry = NULL;
> > > > > +
> > > > > +		if (!dir_emit(ctx, dentry_name, name_len,
> > > > >    			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
> > > > >    			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
> > > > >    			dout("filldir stopping us...\n");
> > > > >    			err = 0;
> > > > > +			for (; i < rinfo->dir_nr; i++) {
> > > > > +				rde = rinfo->dir_entries + i;
> > > > > +				dput(rde->dentry);
> > > > > +				rde->dentry = NULL;
> > > > > +			}
> > > > >    			goto out;
> > > > >    		}
> > > > >    
> > > > > -		/* Reset the lengths to their original allocated vals */
> > > > > -		oname.len = olen;
> > > > >    		ctx->pos++;
> > > > >    	}
> > > > >    
> > > > > @@ -616,8 +612,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > > > >    	err = 0;
> > > > >    	dout("readdir %p file %p done.\n", inode, file);
> > > > >    out:
> > > > > -	ceph_fname_free_buffer(inode, &tname);
> > > > > -	ceph_fname_free_buffer(inode, &oname);
> > > > > +	if (dentry_name)
> > > > > +		kfree(dentry_name);
> > > > >    	return err;
> > > > >    }
> > > > >    
> > > > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > > > index 2bc2f02b84e8..877e699fe43b 100644
> > > > > --- a/fs/ceph/inode.c
> > > > > +++ b/fs/ceph/inode.c
> > > > > @@ -1903,6 +1903,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> > > > >    			goto out;
> > > > >    		}
> > > > >    
> > > > > +		rde->dentry = NULL;
> > > > >    		dname.name = oname.name;
> > > > >    		dname.len = oname.len;
> > > > >    		dname.hash = full_name_hash(parent, dname.name, dname.len);
> > > > > @@ -1963,6 +1964,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> > > > >    			goto retry_lookup;
> > > > >    		}
> > > > >    
> > > > > +		/*
> > > > > +		 * ceph_readdir will use the dentry to get the name
> > > > > +		 * to avoid doing the dencrypt again there.
> > > > > +		 */
> > > > > +		rde->dentry = dget(dn);
> > > > > +
> > > > >    		/* inode */
> > > > >    		if (d_really_is_positive(dn)) {
> > > > >    			in = d_inode(dn);
> > > > > @@ -2025,6 +2032,14 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> > > > >    		dput(dn);
> > > > >    	}
> > > > >    out:
> > > > > +	if (err) {
> > > > > +		for (; i >= 0; i--) {
> > > > > +			struct ceph_mds_reply_dir_entry *rde;
> > > > > +
> > > > > +			rde = rinfo->dir_entries + i;
> > > > > +			dput(rde->dentry);
> > > > > +		}
> > > > > +	}
> > > > >    	if (err == 0 && skipped == 0) {
> > > > >    		set_bit(CEPH_MDS_R_DID_PREPOPULATE, &req->r_req_flags);
> > > > >    		req->r_readdir_cache_idx = cache_ctl.index;
> > > > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > > > index 0dfe24f94567..663d7754d57d 100644
> > > > > --- a/fs/ceph/mds_client.h
> > > > > +++ b/fs/ceph/mds_client.h
> > > > > @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
> > > > >    };
> > > > >    
> > > > >    struct ceph_mds_reply_dir_entry {
> > > > > +	struct dentry		      *dentry;
> > > > >    	char                          *name;
> > > > >    	u8			      *altname;
> > > > >    	u32                           name_len;
> > > > NAK on this patch as it is...
> > > > 
> 

-- 
Jeff Layton <jlayton@kernel.org>
