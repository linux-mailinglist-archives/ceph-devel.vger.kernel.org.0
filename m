Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E35C14D44CC
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Mar 2022 11:36:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241353AbiCJKh5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Mar 2022 05:37:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiCJKhx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Mar 2022 05:37:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CA64C41C
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 02:36:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 09A26CE22C8
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 10:36:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA92C340E8;
        Thu, 10 Mar 2022 10:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646908609;
        bh=410oyzUyqBjnVDB9+LqGrhnG+2I/Y3fiRDt4vk68Vto=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=O7bJ4Y93r64NX8xBW3RaOOF35836tS1esd279clz3yd/ojE7a2CJq5YCS+FHHs3TE
         G3OeUBD+2ZllOTOdg2zoFyeHnTZ2w5OTEypUJbJmdL4PmrJLGjL38kwIUYL02iLjEN
         +sI1Qe8RxM/HMCKASxpB09XNqYPItbHmdEtgD4ahtcV+YTDhyV8nCntKvkuCJyJYdV
         AO0hOn6L83Hfm0Ip1YcKCB19V0I4RfV6hhm7kslrPd3Df9twjZp15nyS+evrkWx+VH
         1/oIHoiDyzcl82/Ijss0GOWltAxzuicTBqZgmg7P1uayGTIGcHByIRB1g8oxEvvYEu
         7VTD9Nd46QeVw==
Message-ID: <b53ce2d4d085f94490e715253cf269a8d5dbdebf.camel@kernel.org>
Subject: Re: [PATCH V7] ceph: do not dencrypt the dentry name twice for
 readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Thu, 10 Mar 2022 05:36:47 -0500
In-Reply-To: <b0605e1e-5c54-d250-8e93-773638d36ab6@redhat.com>
References: <20220309135914.95804-1-xiubli@redhat.com>
         <b0605e1e-5c54-d250-8e93-773638d36ab6@redhat.com>
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

On Thu, 2022-03-10 at 14:08 +0800, Xiubo Li wrote:
> On 3/9/22 9:59 PM, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > For the readdir request the dentries will be pasred and dencrypted
> > in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
> > get the dentry name from the dentry cache instead of parsing and
> > dencrypting them again. This could improve performance.
> > 
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > ---
> > 
> > V7:
> > - Fix the xfstest generic/006 crash bug about the rde->dentry == NULL.
> > 
> > V6:
> > - Remove CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro and use the NAME_MAX
> >    instead, since we are limiting the max length of snapshot name to
> >    240, which is NAME_MAX - 2 * sizeof('_') - sizeof(<inode#>).
> > 
> > V5:
> > - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
> > - release the rde->dentry in destroy_reply_info
> > 
> > 
> > 
> >   fs/ceph/dir.c        | 56 ++++++++++++++++++++------------------------
> >   fs/ceph/inode.c      |  7 ++++++
> >   fs/ceph/mds_client.c |  1 +
> >   fs/ceph/mds_client.h |  1 +
> >   4 files changed, 34 insertions(+), 31 deletions(-)
> > 
> > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > index 6df2a91af236..2397c34e9173 100644
> > --- a/fs/ceph/dir.c
> > +++ b/fs/ceph/dir.c
> > @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> >   	int err;
> >   	unsigned frag = -1;
> >   	struct ceph_mds_reply_info_parsed *rinfo;
> > -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
> > -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
> > +	char *dentry_name = NULL;
> >   
> >   	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
> >   	if (dfi->file_info.flags & CEPH_F_ATEND)
> > @@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> >   		spin_unlock(&ci->i_ceph_lock);
> >   	}
> >   
> > -	err = ceph_fname_alloc_buffer(inode, &tname);
> > -	if (err < 0)
> > -		goto out;
> > -
> > -	err = ceph_fname_alloc_buffer(inode, &oname);
> > -	if (err < 0)
> > -		goto out;
> > -
> >   	/* proceed with a normal readdir */
> >   more:
> >   	/* do we have the correct frag content buffered? */
> > @@ -528,31 +519,36 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> >   			}
> >   		}
> >   	}
> > +
> > +	dentry_name = kmalloc(NAME_MAX, GFP_KERNEL);
> > +	if (!dentry_name) {
> > +		err = -ENOMEM;
> > +		ceph_mdsc_put_request(dfi->last_readdir);
> > +		dfi->last_readdir = NULL;
> > +		goto out;
> > +	}
> > +
> >   	for (; i < rinfo->dir_nr; i++) {
> >   		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> > -		struct ceph_fname fname = { .dir	= inode,
> > -					    .name	= rde->name,
> > -					    .name_len	= rde->name_len,
> > -					    .ctext	= rde->altname,
> > -					    .ctext_len	= rde->altname_len };
> > -		u32 olen = oname.len;
> > -
> > -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> > -		if (err) {
> > -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> > -			       rde->name_len, rde->name, err);
> > -			goto out;
> > -		}
> > +		struct dentry *dn = rde->dentry;
> > +		int name_len;
> >   
> >   		BUG_ON(rde->offset < ctx->pos);
> >   		BUG_ON(!rde->inode.in);
> > +		BUG_ON(!rde->dentry);
> >   
> >   		ctx->pos = rde->offset;
> > -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
> > -		     i, rinfo->dir_nr, ctx->pos,
> > -		     rde->name_len, rde->name, &rde->inode.in);
> >   
> > -		if (!dir_emit(ctx, oname.name, oname.len,
> > +		spin_lock(&dn->d_lock);
> > +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
> > +		name_len = dn->d_name.len;
> > +		spin_unlock(&dn->d_lock);
> > +
> 
> Hi Jeff,
> 
> BTW, does the dn->d_lock is must here ? From the code comments, the 
> d_lock intends to protect the 'd_flag' and 'd_lockref.count'.
> 
> In ceph code I found some places are using the d_lock when accessing the 
> d_name, some are not. And in none ceph code, they will almost never use 
> the d_lock to protect the d_name.
> 

It's probably not needed. The d_name can only change if there are no
other outstanding references to the dentry.

> 
> 
> > +		dentry_name[name_len] = '\0';
> > +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
> > +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
> > +
> > +		if (!dir_emit(ctx, dentry_name, name_len,
> >   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
> >   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
> >   			/*
> > @@ -566,8 +562,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> >   			goto out;
> >   		}
> >   
> > -		/* Reset the lengths to their original allocated vals */
> > -		oname.len = olen;
> >   		ctx->pos++;
> >   	}
> >   
> > @@ -625,8 +619,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> >   	err = 0;
> >   	dout("readdir %p file %p done.\n", inode, file);
> >   out:
> > -	ceph_fname_free_buffer(inode, &tname);
> > -	ceph_fname_free_buffer(inode, &oname);
> > +	if (dentry_name)
> > +		kfree(dentry_name);
> >   	return err;
> >   }
> >   
> > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > index b573a0f33450..19e5275eae1c 100644
> > --- a/fs/ceph/inode.c
> > +++ b/fs/ceph/inode.c
> > @@ -1909,6 +1909,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> >   			goto out;
> >   		}
> >   
> > +		rde->dentry = NULL;
> >   		dname.name = oname.name;
> >   		dname.len = oname.len;
> >   		dname.hash = full_name_hash(parent, dname.name, dname.len);
> > @@ -1969,6 +1970,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> >   			goto retry_lookup;
> >   		}
> >   
> > +		/*
> > +		 * ceph_readdir will use the dentry to get the name
> > +		 * to avoid doing the dencrypt again there.
> > +		 */
> > +		rde->dentry = dget(dn);
> > +
> >   		/* inode */
> >   		if (d_really_is_positive(dn)) {
> >   			in = d_inode(dn);
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 8d704ddd7291..9e0a51ef1dfa 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -733,6 +733,7 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
> >   
> >   		kfree(rde->inode.fscrypt_auth);
> >   		kfree(rde->inode.fscrypt_file);
> > +		dput(rde->dentry);
> >   	}
> >   	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
> >   }
> > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > index 0dfe24f94567..663d7754d57d 100644
> > --- a/fs/ceph/mds_client.h
> > +++ b/fs/ceph/mds_client.h
> > @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
> >   };
> >   
> >   struct ceph_mds_reply_dir_entry {
> > +	struct dentry		      *dentry;
> >   	char                          *name;
> >   	u8			      *altname;
> >   	u32                           name_len;
> 

-- 
Jeff Layton <jlayton@kernel.org>
