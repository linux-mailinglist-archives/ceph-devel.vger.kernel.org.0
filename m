Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF94D3E76
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Mar 2022 01:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233937AbiCJAzG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 19:55:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiCJAzG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 19:55:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7C464B0C50
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 16:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646873644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXUrBzQumKPFgZYt3tfng167z+JTHrZ40Wf19ly8gKE=;
        b=YrYX1jFGwSVyQx0MtNCUuRJkLJtxpiAzTQ8lHTWn9QULv4tn6q1qQNRx6YED0a8I7lg9AF
        NWsfMFXh2D1ermvWCrXsKNwG0PMK80vTkjknLd1oMGxhrmXedtjSgBfCzkA2sa+/yUEknv
        fTKh6vKWuTumtVE8C7RrKx7eEWr+FqI=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-118-QNJoXPY7PbWXF8KPdCkBtw-1; Wed, 09 Mar 2022 19:54:03 -0500
X-MC-Unique: QNJoXPY7PbWXF8KPdCkBtw-1
Received: by mail-pf1-f200.google.com with SMTP id 184-20020a6215c1000000b004f6dc47ec08so2375265pfv.21
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 16:54:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dXUrBzQumKPFgZYt3tfng167z+JTHrZ40Wf19ly8gKE=;
        b=uubPv1tb0NhGfG7pp9WV7O8KU+ev7+AWIJAaHHw/abnI2cPZZfYQ63M5RZ0C3Yvo8I
         QOis35HGMs7+WvXFi/o6niFXqEEZURPA/i5nXw56Crh3xNtZDdM1W4QS4tBwjXEcuztV
         q2Y56TyGO8QwcL8KdHiVqgEsQuiFPQY+fiXHrni5ch4UW939tPrbo2sDdp/Sx5piMP+k
         FZBmVYoLSHtNjwFTg5UGQS+jnxEZcqhcmwPUI7LDIts9F7R4YinCMNj0QKuA1QOBaWQ2
         Eq7XEjsrI/En7rsrKllHCHu3uUEpik1IR7K7rRUqdxMzGRuAbuvEBfmY3Kr4kKxHDHKD
         +BTQ==
X-Gm-Message-State: AOAM532vFzyG1YRcjdgulmtiMohgavi8n3iWjLLpfJqqL5WA2zt1jPQC
        V9L0yNa2qu3FumyK91Ot3GZYCRvotuT8NZx7TBUv+CQdgntfA8neaoWL+YTotMX58Wh1z6d4EuQ
        /D6wcPiMV4PjvpdsVBn8X0pKA+4lGD+/mwjy9onmDmFZkE9UZLA9gD4GLg7+ncI2z6q7KmWA=
X-Received: by 2002:a17:902:8e82:b0:151:777b:6d7 with SMTP id bg2-20020a1709028e8200b00151777b06d7mr2371300plb.172.1646873640943;
        Wed, 09 Mar 2022 16:54:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxq/VODDn01Ltid65v8weJuvCWpeujFXhdKfbcReQ6v7FjdaJPVt6AzWQaLiCZJg5Q96TIWAA==
X-Received: by 2002:a17:902:8e82:b0:151:777b:6d7 with SMTP id bg2-20020a1709028e8200b00151777b06d7mr2371261plb.172.1646873640461;
        Wed, 09 Mar 2022 16:54:00 -0800 (PST)
Received: from [10.72.12.86] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id me8-20020a17090b17c800b001bf9907c41bsm6460750pjb.12.2022.03.09.16.53.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 16:53:59 -0800 (PST)
Subject: Re: [PATCH V7] ceph: do not dencrypt the dentry name twice for
 readdir
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220309135914.95804-1-xiubli@redhat.com>
 <0e27d3f24a7b733b258c37925b27e13087b2972a.camel@kernel.org>
 <67a3ac26-9ef2-57ec-6c29-11721dfe0528@redhat.com>
 <1c7be2321d2001a5eb2de99e9dcb7881620f4a91.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0876d6c5-42ca-1e28-952b-327bacb3ab41@redhat.com>
Date:   Thu, 10 Mar 2022 08:53:53 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1c7be2321d2001a5eb2de99e9dcb7881620f4a91.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/10/22 8:27 AM, Jeff Layton wrote:
> On Thu, 2022-03-10 at 08:20 +0800, Xiubo Li wrote:
>> On 3/9/22 10:50 PM, Jeff Layton wrote:
>>> On Wed, 2022-03-09 at 21:59 +0800, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> For the readdir request the dentries will be pasred and dencrypted
>>>> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
>>>> get the dentry name from the dentry cache instead of parsing and
>>>> dencrypting them again. This could improve performance.
>>>>
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>>
>>>> V7:
>>>> - Fix the xfstest generic/006 crash bug about the rde->dentry == NULL.
>>>>
>>>> V6:
>>>> - Remove CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro and use the NAME_MAX
>>>>     instead, since we are limiting the max length of snapshot name to
>>>>     240, which is NAME_MAX - 2 * sizeof('_') - sizeof(<inode#>).
>>>>
>>>> V5:
>>>> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
>>>> - release the rde->dentry in destroy_reply_info
>>>>
>>>>
>>>>
>>>>    fs/ceph/dir.c        | 56 ++++++++++++++++++++------------------------
>>>>    fs/ceph/inode.c      |  7 ++++++
>>>>    fs/ceph/mds_client.c |  1 +
>>>>    fs/ceph/mds_client.h |  1 +
>>>>    4 files changed, 34 insertions(+), 31 deletions(-)
>>>>
>>>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>>>> index 6df2a91af236..2397c34e9173 100644
>>>> --- a/fs/ceph/dir.c
>>>> +++ b/fs/ceph/dir.c
>>>> @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>>>    	int err;
>>>>    	unsigned frag = -1;
>>>>    	struct ceph_mds_reply_info_parsed *rinfo;
>>>> -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
>>>> -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
>>>> +	char *dentry_name = NULL;
>>>>    
>>>>    	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
>>>>    	if (dfi->file_info.flags & CEPH_F_ATEND)
>>>> @@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>>>    		spin_unlock(&ci->i_ceph_lock);
>>>>    	}
>>>>    
>>>> -	err = ceph_fname_alloc_buffer(inode, &tname);
>>>> -	if (err < 0)
>>>> -		goto out;
>>>> -
>>>> -	err = ceph_fname_alloc_buffer(inode, &oname);
>>>> -	if (err < 0)
>>>> -		goto out;
>>>> -
>>>>    	/* proceed with a normal readdir */
>>>>    more:
>>>>    	/* do we have the correct frag content buffered? */
>>>> @@ -528,31 +519,36 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>>>    			}
>>>>    		}
>>>>    	}
>>>> +
>>>> +	dentry_name = kmalloc(NAME_MAX, GFP_KERNEL);
>>>> +	if (!dentry_name) {
>>>> +		err = -ENOMEM;
>>>> +		ceph_mdsc_put_request(dfi->last_readdir);
>>>> +		dfi->last_readdir = NULL;
>>>> +		goto out;
>>>> +	}
>>>> +
>>>>    	for (; i < rinfo->dir_nr; i++) {
>>>>    		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
>>>> -		struct ceph_fname fname = { .dir	= inode,
>>>> -					    .name	= rde->name,
>>>> -					    .name_len	= rde->name_len,
>>>> -					    .ctext	= rde->altname,
>>>> -					    .ctext_len	= rde->altname_len };
>>>> -		u32 olen = oname.len;
>>>> -
>>>> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
>>>> -		if (err) {
>>>> -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
>>>> -			       rde->name_len, rde->name, err);
>>>> -			goto out;
>>>> -		}
>>>> +		struct dentry *dn = rde->dentry;
>>>> +		int name_len;
>>>>    
>>>>    		BUG_ON(rde->offset < ctx->pos);
>>>>    		BUG_ON(!rde->inode.in);
>>>> +		BUG_ON(!rde->dentry);
>>>>    
>>>>    		ctx->pos = rde->offset;
>>>> -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
>>>> -		     i, rinfo->dir_nr, ctx->pos,
>>>> -		     rde->name_len, rde->name, &rde->inode.in);
>>>>    
>>>> -		if (!dir_emit(ctx, oname.name, oname.len,
>>>> +		spin_lock(&dn->d_lock);
>>>> +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
>>>> +		name_len = dn->d_name.len;
>>>> +		spin_unlock(&dn->d_lock);
>>>> +
>>>> +		dentry_name[name_len] = '\0';
>>>> +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
>>>> +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
>>>> +
>>>> +		if (!dir_emit(ctx, dentry_name, name_len,
>>>>    			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>>>>    			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>>>>    			/*
>>>> @@ -566,8 +562,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>>>    			goto out;
>>>>    		}
>>>>    
>>>> -		/* Reset the lengths to their original allocated vals */
>>>> -		oname.len = olen;
>>>>    		ctx->pos++;
>>>>    	}
>>>>    
>>>> @@ -625,8 +619,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>>>    	err = 0;
>>>>    	dout("readdir %p file %p done.\n", inode, file);
>>>>    out:
>>>> -	ceph_fname_free_buffer(inode, &tname);
>>>> -	ceph_fname_free_buffer(inode, &oname);
>>>> +	if (dentry_name)
>>>> +		kfree(dentry_name);
>>>>    	return err;
>>>>    }
>>>>    
>>>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>>>> index b573a0f33450..19e5275eae1c 100644
>>>> --- a/fs/ceph/inode.c
>>>> +++ b/fs/ceph/inode.c
>>>> @@ -1909,6 +1909,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>>>>    			goto out;
>>>>    		}
>>>>    
>>>> +		rde->dentry = NULL;
>>>>    		dname.name = oname.name;
>>>>    		dname.len = oname.len;
>>>>    		dname.hash = full_name_hash(parent, dname.name, dname.len);
>>>> @@ -1969,6 +1970,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>>>>    			goto retry_lookup;
>>>>    		}
>>>>    
>>>> +		/*
>>>> +		 * ceph_readdir will use the dentry to get the name
>>>> +		 * to avoid doing the dencrypt again there.
>>>> +		 */
>>>> +		rde->dentry = dget(dn);
>>>> +
>>>>    		/* inode */
>>>>    		if (d_really_is_positive(dn)) {
>>>>    			in = d_inode(dn);
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 8d704ddd7291..9e0a51ef1dfa 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -733,6 +733,7 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
>>>>    
>>>>    		kfree(rde->inode.fscrypt_auth);
>>>>    		kfree(rde->inode.fscrypt_file);
>>>> +		dput(rde->dentry);
>>>>    	}
>>>>    	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
>>>>    }
>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>> index 0dfe24f94567..663d7754d57d 100644
>>>> --- a/fs/ceph/mds_client.h
>>>> +++ b/fs/ceph/mds_client.h
>>>> @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
>>>>    };
>>>>    
>>>>    struct ceph_mds_reply_dir_entry {
>>>> +	struct dentry		      *dentry;
>>>>    	char                          *name;
>>>>    	u8			      *altname;
>>>>    	u32                           name_len;
>>> Still buggy. This time generic/013 triggered this:
>>>
>>> [ 1970.839019] run fstests generic/013 at 2022-03-09 09:48:42
>>> [ 2001.133838] ==================================================================
>>> [ 2001.138595] BUG: KASAN: slab-out-of-bounds in ceph_readdir+0x3f4/0x1dd0 [ceph]
>>> [ 2001.141997] Write of size 1 at addr ffff888120070aff by task fsstress/8682
>>> [ 2001.144897]
>>> [ 2001.145670] CPU: 7 PID: 8682 Comm: fsstress Tainted: G            E     5.17.0-rc6+ #172
>>> [ 2001.149132] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
>>> [ 2001.152477] Call Trace:
>>> [ 2001.153609]  <TASK>
>>> [ 2001.154482]  dump_stack_lvl+0x59/0x73
>>> [ 2001.155697]  print_address_description.constprop.0+0x1f/0x150
>>> [ 2001.158021]  ? ceph_readdir+0x3f4/0x1dd0 [ceph]
>>> [ 2001.159654]  kasan_report.cold+0x7f/0x11b
>>> [ 2001.160951]  ? ceph_readdir+0x3f4/0x1dd0 [ceph]
>>> [ 2001.168084]  ceph_readdir+0x3f4/0x1dd0 [ceph]
>>> [ 2001.173258]  ? ceph_d_revalidate+0x7e0/0x7e0 [ceph]
>>> [ 2001.178293]  ? down_write_killable+0xc7/0x130
>>> [ 2001.182782]  ? __down_interruptible+0x1d0/0x1d0
>>> [ 2001.187246]  iterate_dir+0x107/0x2e0
>>> [ 2001.192677]  __x64_sys_getdents64+0xe2/0x1b0
>>> [ 2001.197570]  ? filldir+0x270/0x270
>>> [ 2001.202806]  ? __ia32_sys_getdents+0x1a0/0x1a0
>>> [ 2001.207415]  ? lockdep_hardirqs_on_prepare+0x129/0x220
>>> [ 2001.211782]  ? syscall_enter_from_user_mode+0x21/0x70
>>> [ 2001.216466]  do_syscall_64+0x3b/0x90
>>> [ 2001.220674]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> [ 2001.225674] RIP: 0033:0x7f159a774fd7
>>> [ 2001.230170] Code: 19 fb ff 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 21 0e 12 00 f7 d8 64 89 02 48
>>> [ 2001.240821] RSP: 002b:00007ffff90c35d8 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
>>> [ 2001.247670] RAX: ffffffffffffffda RBX: 0000000001186130 RCX: 00007f159a774fd7
>>> [ 2001.255057] RDX: 0000000000010000 RSI: 0000000001186130 RDI: 0000000000000003
>>> [ 2001.262428] RBP: 0000000001186104 R08: 0000000000000003 R09: 0000000000000000
>>> [ 2001.269057] R10: 0000000000000000 R11: 0000000000000293 R12: ffffffffffffff80
>>> [ 2001.275079] R13: 0000000000000019 R14: 0000000001186100 R15: 00007f159a6996c0
>>> [ 2001.282429]  </TASK>
>>> [ 2001.287900]
>>> [ 2001.291963] Allocated by task 8682:
>>> [ 2001.296303]  kasan_save_stack+0x1e/0x40
>>> [ 2001.300491]  __kasan_kmalloc+0xa9/0xd0
>>> [ 2001.304792]  ceph_readdir+0x2ab/0x1dd0 [ceph]
>>> [ 2001.309093]  iterate_dir+0x107/0x2e0
>>> [ 2001.313291]  __x64_sys_getdents64+0xe2/0x1b0
>>> [ 2001.317705]  do_syscall_64+0x3b/0x90
>>> [ 2001.322210]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>>> [ 2001.327112]
>>> [ 2001.331092] The buggy address belongs to the object at ffff888120070a00
>>> [ 2001.331092]  which belongs to the cache kmalloc-256 of size 256
>>> [ 2001.341495] The buggy address is located 255 bytes inside of
>>> [ 2001.341495]  256-byte region [ffff888120070a00, ffff888120070b00)
>>> [ 2001.352252] The buggy address belongs to the page:
>>> [ 2001.357836] page:0000000089466360 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x120070
>>> [ 2001.364225] head:0000000089466360 order:2 compound_mapcount:0 compound_pincount:0
>>> [ 2001.370091] flags: 0x17ffffc0010200(slab|head|node=0|zone=2|lastcpupid=0x1fffff)
>>> [ 2001.375349] raw: 0017ffffc0010200 ffffea00048d7e00 dead000000000002 ffff888100042b40
>>> [ 2001.380833] raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
>>> [ 2001.386079] page dumped because: kasan: bad access detected
>>> [ 2001.390919]
>>> [ 2001.395163] Memory state around the buggy address:
>>> [ 2001.399901]  ffff888120070980: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> [ 2001.405479]  ffff888120070a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>>> [ 2001.410888] >ffff888120070a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 07
>>> [ 2001.416090]                                                                 ^
>>> [ 2001.422577]  ffff888120070b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> [ 2001.430562]  ffff888120070b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> [ 2001.438474] ==================================================================
>>> [ 2001.446565] Disabling lock debugging due to kernel taint
>>>
>> Hi Jeff,
>>
>> Yesterday I also test this and others, and I couldn't reproduce it. Just
>> now I tried several time still worked well.
>>
>> [root@lxbceph1 xfstests]# ./check generic/013
>> FSTYP         -- ceph
>> PLATFORM      -- Linux/x86_64 lxbceph1 5.17.0-rc6+
>> MKFS_OPTIONS  -- 10.72.47.117:40437:/testB
>> MOUNT_OPTIONS -- -o
>> test_dummy_encryption,name=admin,nowsync,copyfrom,rasize=4096 -o
>> context=system_u:object_r:root_t:s0 10.72.47.117:40437:/testB /mnt/kcephfs.B
>>
>> generic/013 102s ... 99s
>> Ran: generic/013
>> Passed all 1 tests
>>
>> I there anything different with yours ? Such as the options, etc.
>>
> Do you have KASAN turned on? I generally run with that enabled for most
> of my testing (for this reason).

Yeah, me too. The config is:


8443 CONFIG_KASAN=y
8444 CONFIG_KASAN_GENERIC=y
8445 CONFIG_KASAN_OUTLINE=y
8446 # CONFIG_KASAN_INLINE is not set
8447 CONFIG_KASAN_STACK=y
8448 # CONFIG_KASAN_VMALLOC is not set
8449 # CONFIG_KASAN_MODULE_TEST is not set
8450 CONFIG_HAVE_ARCH_KFENCE=y
8451 # CONFIG_KFENCE is not set
8452 # end of Memory Debugging
8453
8454 CONFIG_DEBUG_SHIRQ=y



>
> Also, I was testing with '-o test_dummy_encryption' enabled as well.
> That may be a factor here.

Please see my above test I also added this.

BTW, could you attach your objdump for fs/ceph/dir.o ? Mine seem 
different with the dump stack you past.

[ 2001.168084]  ceph_readdir+0x3f4/0x1dd0 [ceph]

The totoal length is 0x1dd0 ? But mine is larger than this. Not sure 
whether there has other config is different with yours.

I base the latest wip-fscrypt branch.

- XIubo

