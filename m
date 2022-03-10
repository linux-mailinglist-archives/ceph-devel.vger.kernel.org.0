Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914324D3E14
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Mar 2022 01:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbiCJA21 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 19:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbiCJA21 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 19:28:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED7DCF9
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 16:27:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AD0F60ED2
        for <ceph-devel@vger.kernel.org>; Thu, 10 Mar 2022 00:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC8EC340E8;
        Thu, 10 Mar 2022 00:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646872045;
        bh=+iP5PELSwBZcEdXVk5XY729frWET9MwmO3SQETb6vjQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Nv8UVDTyVGKhDK/ZiEpI/LhLLrO/yh4o05oGvEZXjCIJMvBqbpiL18P5eIe1LL4Qe
         iLHsRDfeqTRAXvwVqWtqNwvYwNSKqGKQjjKsZvTW30v8fhLiFwH1MVYBBzGxjbHY2d
         7OHBTRiiYb3y0zmiXvU4De53AqDg41gdyoNnrwOt93tJplRLP6RqaMkG/QAePSVr1e
         5UXXv/kBa24ps2dZLF59PXYSxqxdqIeBvFU2ihshKi48dPjTHkWArYk+UWHNTiZ4pY
         XjXjmI53dUHEWmuekjWuLBtsY5yEGOEl18fuM6So7ED8K7LkX3VosMZepHqVD7jn3e
         Ahh3vvuU2jNLg==
Message-ID: <1c7be2321d2001a5eb2de99e9dcb7881620f4a91.camel@kernel.org>
Subject: Re: [PATCH V7] ceph: do not dencrypt the dentry name twice for
 readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Wed, 09 Mar 2022 19:27:23 -0500
In-Reply-To: <67a3ac26-9ef2-57ec-6c29-11721dfe0528@redhat.com>
References: <20220309135914.95804-1-xiubli@redhat.com>
         <0e27d3f24a7b733b258c37925b27e13087b2972a.camel@kernel.org>
         <67a3ac26-9ef2-57ec-6c29-11721dfe0528@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2022-03-10 at 08:20 +0800, Xiubo Li wrote:
> On 3/9/22 10:50 PM, Jeff Layton wrote:
> > On Wed, 2022-03-09 at 21:59 +0800, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > For the readdir request the dentries will be pasred and dencrypted
> > > in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
> > > get the dentry name from the dentry cache instead of parsing and
> > > dencrypting them again. This could improve performance.
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > > 
> > > V7:
> > > - Fix the xfstest generic/006 crash bug about the rde->dentry == NULL.
> > > 
> > > V6:
> > > - Remove CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro and use the NAME_MAX
> > >    instead, since we are limiting the max length of snapshot name to
> > >    240, which is NAME_MAX - 2 * sizeof('_') - sizeof(<inode#>).
> > > 
> > > V5:
> > > - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
> > > - release the rde->dentry in destroy_reply_info
> > > 
> > > 
> > > 
> > >   fs/ceph/dir.c        | 56 ++++++++++++++++++++------------------------
> > >   fs/ceph/inode.c      |  7 ++++++
> > >   fs/ceph/mds_client.c |  1 +
> > >   fs/ceph/mds_client.h |  1 +
> > >   4 files changed, 34 insertions(+), 31 deletions(-)
> > > 
> > > diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> > > index 6df2a91af236..2397c34e9173 100644
> > > --- a/fs/ceph/dir.c
> > > +++ b/fs/ceph/dir.c
> > > @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > >   	int err;
> > >   	unsigned frag = -1;
> > >   	struct ceph_mds_reply_info_parsed *rinfo;
> > > -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
> > > -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
> > > +	char *dentry_name = NULL;
> > >   
> > >   	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
> > >   	if (dfi->file_info.flags & CEPH_F_ATEND)
> > > @@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > >   		spin_unlock(&ci->i_ceph_lock);
> > >   	}
> > >   
> > > -	err = ceph_fname_alloc_buffer(inode, &tname);
> > > -	if (err < 0)
> > > -		goto out;
> > > -
> > > -	err = ceph_fname_alloc_buffer(inode, &oname);
> > > -	if (err < 0)
> > > -		goto out;
> > > -
> > >   	/* proceed with a normal readdir */
> > >   more:
> > >   	/* do we have the correct frag content buffered? */
> > > @@ -528,31 +519,36 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > >   			}
> > >   		}
> > >   	}
> > > +
> > > +	dentry_name = kmalloc(NAME_MAX, GFP_KERNEL);
> > > +	if (!dentry_name) {
> > > +		err = -ENOMEM;
> > > +		ceph_mdsc_put_request(dfi->last_readdir);
> > > +		dfi->last_readdir = NULL;
> > > +		goto out;
> > > +	}
> > > +
> > >   	for (; i < rinfo->dir_nr; i++) {
> > >   		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> > > -		struct ceph_fname fname = { .dir	= inode,
> > > -					    .name	= rde->name,
> > > -					    .name_len	= rde->name_len,
> > > -					    .ctext	= rde->altname,
> > > -					    .ctext_len	= rde->altname_len };
> > > -		u32 olen = oname.len;
> > > -
> > > -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> > > -		if (err) {
> > > -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> > > -			       rde->name_len, rde->name, err);
> > > -			goto out;
> > > -		}
> > > +		struct dentry *dn = rde->dentry;
> > > +		int name_len;
> > >   
> > >   		BUG_ON(rde->offset < ctx->pos);
> > >   		BUG_ON(!rde->inode.in);
> > > +		BUG_ON(!rde->dentry);
> > >   
> > >   		ctx->pos = rde->offset;
> > > -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
> > > -		     i, rinfo->dir_nr, ctx->pos,
> > > -		     rde->name_len, rde->name, &rde->inode.in);
> > >   
> > > -		if (!dir_emit(ctx, oname.name, oname.len,
> > > +		spin_lock(&dn->d_lock);
> > > +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
> > > +		name_len = dn->d_name.len;
> > > +		spin_unlock(&dn->d_lock);
> > > +
> > > +		dentry_name[name_len] = '\0';
> > > +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
> > > +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
> > > +
> > > +		if (!dir_emit(ctx, dentry_name, name_len,
> > >   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
> > >   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
> > >   			/*
> > > @@ -566,8 +562,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > >   			goto out;
> > >   		}
> > >   
> > > -		/* Reset the lengths to their original allocated vals */
> > > -		oname.len = olen;
> > >   		ctx->pos++;
> > >   	}
> > >   
> > > @@ -625,8 +619,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
> > >   	err = 0;
> > >   	dout("readdir %p file %p done.\n", inode, file);
> > >   out:
> > > -	ceph_fname_free_buffer(inode, &tname);
> > > -	ceph_fname_free_buffer(inode, &oname);
> > > +	if (dentry_name)
> > > +		kfree(dentry_name);
> > >   	return err;
> > >   }
> > >   
> > > diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> > > index b573a0f33450..19e5275eae1c 100644
> > > --- a/fs/ceph/inode.c
> > > +++ b/fs/ceph/inode.c
> > > @@ -1909,6 +1909,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> > >   			goto out;
> > >   		}
> > >   
> > > +		rde->dentry = NULL;
> > >   		dname.name = oname.name;
> > >   		dname.len = oname.len;
> > >   		dname.hash = full_name_hash(parent, dname.name, dname.len);
> > > @@ -1969,6 +1970,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
> > >   			goto retry_lookup;
> > >   		}
> > >   
> > > +		/*
> > > +		 * ceph_readdir will use the dentry to get the name
> > > +		 * to avoid doing the dencrypt again there.
> > > +		 */
> > > +		rde->dentry = dget(dn);
> > > +
> > >   		/* inode */
> > >   		if (d_really_is_positive(dn)) {
> > >   			in = d_inode(dn);
> > > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > > index 8d704ddd7291..9e0a51ef1dfa 100644
> > > --- a/fs/ceph/mds_client.c
> > > +++ b/fs/ceph/mds_client.c
> > > @@ -733,6 +733,7 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
> > >   
> > >   		kfree(rde->inode.fscrypt_auth);
> > >   		kfree(rde->inode.fscrypt_file);
> > > +		dput(rde->dentry);
> > >   	}
> > >   	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
> > >   }
> > > diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> > > index 0dfe24f94567..663d7754d57d 100644
> > > --- a/fs/ceph/mds_client.h
> > > +++ b/fs/ceph/mds_client.h
> > > @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
> > >   };
> > >   
> > >   struct ceph_mds_reply_dir_entry {
> > > +	struct dentry		      *dentry;
> > >   	char                          *name;
> > >   	u8			      *altname;
> > >   	u32                           name_len;
> > 
> > Still buggy. This time generic/013 triggered this:
> > 
> > [ 1970.839019] run fstests generic/013 at 2022-03-09 09:48:42
> > [ 2001.133838] ==================================================================
> > [ 2001.138595] BUG: KASAN: slab-out-of-bounds in ceph_readdir+0x3f4/0x1dd0 [ceph]
> > [ 2001.141997] Write of size 1 at addr ffff888120070aff by task fsstress/8682
> > [ 2001.144897]
> > [ 2001.145670] CPU: 7 PID: 8682 Comm: fsstress Tainted: G            E     5.17.0-rc6+ #172
> > [ 2001.149132] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
> > [ 2001.152477] Call Trace:
> > [ 2001.153609]  <TASK>
> > [ 2001.154482]  dump_stack_lvl+0x59/0x73
> > [ 2001.155697]  print_address_description.constprop.0+0x1f/0x150
> > [ 2001.158021]  ? ceph_readdir+0x3f4/0x1dd0 [ceph]
> > [ 2001.159654]  kasan_report.cold+0x7f/0x11b
> > [ 2001.160951]  ? ceph_readdir+0x3f4/0x1dd0 [ceph]
> > [ 2001.168084]  ceph_readdir+0x3f4/0x1dd0 [ceph]
> > [ 2001.173258]  ? ceph_d_revalidate+0x7e0/0x7e0 [ceph]
> > [ 2001.178293]  ? down_write_killable+0xc7/0x130
> > [ 2001.182782]  ? __down_interruptible+0x1d0/0x1d0
> > [ 2001.187246]  iterate_dir+0x107/0x2e0
> > [ 2001.192677]  __x64_sys_getdents64+0xe2/0x1b0
> > [ 2001.197570]  ? filldir+0x270/0x270
> > [ 2001.202806]  ? __ia32_sys_getdents+0x1a0/0x1a0
> > [ 2001.207415]  ? lockdep_hardirqs_on_prepare+0x129/0x220
> > [ 2001.211782]  ? syscall_enter_from_user_mode+0x21/0x70
> > [ 2001.216466]  do_syscall_64+0x3b/0x90
> > [ 2001.220674]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [ 2001.225674] RIP: 0033:0x7f159a774fd7
> > [ 2001.230170] Code: 19 fb ff 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 21 0e 12 00 f7 d8 64 89 02 48
> > [ 2001.240821] RSP: 002b:00007ffff90c35d8 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
> > [ 2001.247670] RAX: ffffffffffffffda RBX: 0000000001186130 RCX: 00007f159a774fd7
> > [ 2001.255057] RDX: 0000000000010000 RSI: 0000000001186130 RDI: 0000000000000003
> > [ 2001.262428] RBP: 0000000001186104 R08: 0000000000000003 R09: 0000000000000000
> > [ 2001.269057] R10: 0000000000000000 R11: 0000000000000293 R12: ffffffffffffff80
> > [ 2001.275079] R13: 0000000000000019 R14: 0000000001186100 R15: 00007f159a6996c0
> > [ 2001.282429]  </TASK>
> > [ 2001.287900]
> > [ 2001.291963] Allocated by task 8682:
> > [ 2001.296303]  kasan_save_stack+0x1e/0x40
> > [ 2001.300491]  __kasan_kmalloc+0xa9/0xd0
> > [ 2001.304792]  ceph_readdir+0x2ab/0x1dd0 [ceph]
> > [ 2001.309093]  iterate_dir+0x107/0x2e0
> > [ 2001.313291]  __x64_sys_getdents64+0xe2/0x1b0
> > [ 2001.317705]  do_syscall_64+0x3b/0x90
> > [ 2001.322210]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > [ 2001.327112]
> > [ 2001.331092] The buggy address belongs to the object at ffff888120070a00
> > [ 2001.331092]  which belongs to the cache kmalloc-256 of size 256
> > [ 2001.341495] The buggy address is located 255 bytes inside of
> > [ 2001.341495]  256-byte region [ffff888120070a00, ffff888120070b00)
> > [ 2001.352252] The buggy address belongs to the page:
> > [ 2001.357836] page:0000000089466360 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x120070
> > [ 2001.364225] head:0000000089466360 order:2 compound_mapcount:0 compound_pincount:0
> > [ 2001.370091] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
> > [ 2001.375349] raw: 0017ffffc0010200 ffffea00048d7e00 dead000000000002 ffff888100042b40
> > [ 2001.380833] raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
> > [ 2001.386079] page dumped because: kasan: bad access detected
> > [ 2001.390919]
> > [ 2001.395163] Memory state around the buggy address:
> > [ 2001.399901]  ffff888120070980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > [ 2001.405479]  ffff888120070a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> > [ 2001.410888] >ffff888120070a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07
> > [ 2001.416090]                                                                 ^
> > [ 2001.422577]  ffff888120070b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > [ 2001.430562]  ffff888120070b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > [ 2001.438474] ==================================================================
> > [ 2001.446565] Disabling lock debugging due to kernel taint
> > 
> Hi Jeff,
> 
> Yesterday I also test this and others, and I couldn't reproduce it. Just 
> now I tried several time still worked well.
> 
> [root@lxbceph1 xfstests]# ./check generic/013
> FSTYP         -- ceph
> PLATFORM      -- Linux/x86_64 lxbceph1 5.17.0-rc6+
> MKFS_OPTIONS  -- 10.72.47.117:40437:/testB
> MOUNT_OPTIONS -- -o 
> test_dummy_encryption,name=admin,nowsync,copyfrom,rasize=4096 -o 
> context=system_u:object_r:root_t:s0 10.72.47.117:40437:/testB /mnt/kcephfs.B
> 
> generic/013 102s ... 99s
> Ran: generic/013
> Passed all 1 tests
> 
> I there anything different with yours ? Such as the options, etc.
> 

Do you have KASAN turned on? I generally run with that enabled for most
of my testing (for this reason).

Also, I was testing with '-o test_dummy_encryption' enabled as well.
That may be a factor here.
-- 
Jeff Layton <jlayton@kernel.org>
