Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C3D4D3030
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 14:44:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiCINpI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 08:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231710AbiCINpG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 08:45:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2545D13EFAF
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 05:44:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646833443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BFIBiGStA0rTq5dUULE3WglszVMv2eUERP8Hv8WDQCA=;
        b=QIyHC7gOfAvaw9em9ekcJ0b1aL51X8Zmt/yVeQqqxhZw/3POMwefjM7YDOP53/FXGCEx1l
        RhkpaqeCSs83jDOzzCUnR3cXGLOS7Ji8AZYzrjibqxiV2hkaoa9hnzHDdBVyA/viBF9R3D
        m6qof0YcA6Nh/z1sjpacSmbz7Obm7Tg=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-158-RhfU8KMkNYmFINAemnyYYw-1; Wed, 09 Mar 2022 08:44:02 -0500
X-MC-Unique: RhfU8KMkNYmFINAemnyYYw-1
Received: by mail-pl1-f200.google.com with SMTP id z10-20020a170902708a00b0014fc3888923so1037236plk.22
        for <ceph-devel@vger.kernel.org>; Wed, 09 Mar 2022 05:44:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=BFIBiGStA0rTq5dUULE3WglszVMv2eUERP8Hv8WDQCA=;
        b=iFivxeisokHrGbvJaShcmQAxzXpzypTl1fMHqnmP86S4h7UnE+lLdTb7EzcaeN5Zzx
         EICKxSTKrtCnsuUQHSkmmThyLCSgJPfZdc30jKqcEhPpe6ZpEWBVDwaXfqJKJYroMWwc
         V6QxG3T5PdrSPmJOfBA/9g3vkJo3lbtI8lSIFTl/PM5azyuhS8KNLA9ICv15uqrqwK1t
         /i4BWRi6FdhWg/VQ4bSjeTAYi5NhrZjlPVJWoT6ZWffDigXMpv61J4Qvmkj/dFzH3v3D
         NEARaTOIZs2roHHF4QJoNv0F0O2Z3I0Gg+dxzyyFS9T/xy2ITM+Vv+rp206bWIw1Pfb4
         Vglw==
X-Gm-Message-State: AOAM531+Wh8wV/SV36bUa0hQ4B4NA7kpmSv8Y+ET5x5yelwtx/xZUz4H
        SjYLq1wKVI5V/0fUk6AcGZit93Cq58tbygzluweyHSN+ED5nHaVP4hICmQjAmN4fiig2shwUAha
        3Bfgen2ssOD+dJnr/jyFrYBq4B1X+EC9MIxhrExfU/l2BA6Rre8KG6xbij/V+1H+zsrt12Pw=
X-Received: by 2002:a17:902:ce8b:b0:153:191:b263 with SMTP id f11-20020a170902ce8b00b001530191b263mr3312423plg.47.1646833439843;
        Wed, 09 Mar 2022 05:43:59 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzznbCavrghYgQ9LUJYqafY6Km6tBZI1Rpv1PuS4fZRRXo+8AG44QoPq+EtRh0nAWPTnYgMcg==
X-Received: by 2002:a17:902:ce8b:b0:153:191:b263 with SMTP id f11-20020a170902ce8b00b001530191b263mr3312379plg.47.1646833439317;
        Wed, 09 Mar 2022 05:43:59 -0800 (PST)
Received: from [10.72.12.86] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a15-20020a637f0f000000b00372e075b2efsm2544342pgd.30.2022.03.09.05.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 05:43:58 -0800 (PST)
Subject: Re: [PATCH v6] ceph: do not dencrypt the dentry name twice for
 readdir
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
References: <20220309122556.46503-1-xiubli@redhat.com>
 <6fef272c748aa9bf95a27ff9f2a0b9e20662e88d.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <59d5693d-ab68-f127-aea8-071ebd598256@redhat.com>
Date:   Wed, 9 Mar 2022 21:43:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <6fef272c748aa9bf95a27ff9f2a0b9e20662e88d.camel@kernel.org>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
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


On 3/9/22 9:05 PM, Jeff Layton wrote:
> On Wed, 2022-03-09 at 20:25 +0800, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For the readdir request the dentries will be pasred and dencrypted
>> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
>> get the dentry name from the dentry cache instead of parsing and
>> dencrypting them again. This could improve performance.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>
>> V6:
>> - Remove CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro and use the NAME_MAX
>>    instead, since we are limiting the max length of snapshot name to
>>    240, which is NAME_MAX - 2 * sizeof('_') - sizeof(<inode#>).
>>
>> V5:
>> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
>> - release the rde->dentry in destroy_reply_info
>>
>>
>>
>>   fs/ceph/dir.c        | 59 +++++++++++++++++++++-----------------------
>>   fs/ceph/inode.c      |  7 ++++++
>>   fs/ceph/mds_client.c |  2 ++
>>   fs/ceph/mds_client.h |  1 +
>>   4 files changed, 38 insertions(+), 31 deletions(-)
>>
>> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
>> index 6df2a91af236..19321a1f7399 100644
>> --- a/fs/ceph/dir.c
>> +++ b/fs/ceph/dir.c
>> @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   	int err;
>>   	unsigned frag = -1;
>>   	struct ceph_mds_reply_info_parsed *rinfo;
>> -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
>> -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
>> +	char *dentry_name = NULL;
>>   
>>   	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
>>   	if (dfi->file_info.flags & CEPH_F_ATEND)
>> @@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   		spin_unlock(&ci->i_ceph_lock);
>>   	}
>>   
>> -	err = ceph_fname_alloc_buffer(inode, &tname);
>> -	if (err < 0)
>> -		goto out;
>> -
>> -	err = ceph_fname_alloc_buffer(inode, &oname);
>> -	if (err < 0)
>> -		goto out;
>> -
>>   	/* proceed with a normal readdir */
>>   more:
>>   	/* do we have the correct frag content buffered? */
>> @@ -528,31 +519,39 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   			}
>>   		}
>>   	}
>> +
>> +	dentry_name = kmalloc(NAME_MAX, GFP_KERNEL);
>> +	if (!dentry_name) {
>> +		err = -ENOMEM;
>> +		ceph_mdsc_put_request(dfi->last_readdir);
>> +		dfi->last_readdir = NULL;
>> +		goto out;
>> +	}
>> +
>>   	for (; i < rinfo->dir_nr; i++) {
>>   		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
>> -		struct ceph_fname fname = { .dir	= inode,
>> -					    .name	= rde->name,
>> -					    .name_len	= rde->name_len,
>> -					    .ctext	= rde->altname,
>> -					    .ctext_len	= rde->altname_len };
>> -		u32 olen = oname.len;
>> -
>> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
>> -		if (err) {
>> -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
>> -			       rde->name_len, rde->name, err);
>> -			goto out;
>> -		}
>> +		struct dentry *dn = rde->dentry;
>> +		int name_len;
>>   
>>   		BUG_ON(rde->offset < ctx->pos);
>>   		BUG_ON(!rde->inode.in);
>> +		BUG_ON(!rde->dentry);
>>   
>>   		ctx->pos = rde->offset;
>> -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
>> -		     i, rinfo->dir_nr, ctx->pos,
>> -		     rde->name_len, rde->name, &rde->inode.in);
>>   
>> -		if (!dir_emit(ctx, oname.name, oname.len,
>> +		spin_lock(&dn->d_lock);
>> +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
>> +		name_len = dn->d_name.len;
>> +		spin_unlock(&dn->d_lock);
>> +
>> +		dentry_name[name_len] = '\0';
>> +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
>> +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
>> +
>> +		dput(dn);
>> +		rde->dentry = NULL;
>> +

It's buggy here.

In case the the dir_emit() just fails, the rde->dentry has been set to 
NULL, but the file->f_pos won't set to next rde, so when the next 
readdir comes, we will his this bug.

Since will put all the rde->dentry in the 'destroy_reply_info()' when 
releasing the req, so this is not needed.

I will remove the above two line and test it locally.

Thanks.

- XIubo


>> +		if (!dir_emit(ctx, dentry_name, name_len,
>>   			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>>   			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>>   			/*
>> @@ -566,8 +565,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   			goto out;
>>   		}
>>   
>> -		/* Reset the lengths to their original allocated vals */
>> -		oname.len = olen;
>>   		ctx->pos++;
>>   	}
>>   
>> @@ -625,8 +622,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>>   	err = 0;
>>   	dout("readdir %p file %p done.\n", inode, file);
>>   out:
>> -	ceph_fname_free_buffer(inode, &tname);
>> -	ceph_fname_free_buffer(inode, &oname);
>> +	if (dentry_name)
>> +		kfree(dentry_name);
>>   	return err;
>>   }
>>   
>> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
>> index b573a0f33450..19e5275eae1c 100644
>> --- a/fs/ceph/inode.c
>> +++ b/fs/ceph/inode.c
>> @@ -1909,6 +1909,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>>   			goto out;
>>   		}
>>   
>> +		rde->dentry = NULL;
>>   		dname.name = oname.name;
>>   		dname.len = oname.len;
>>   		dname.hash = full_name_hash(parent, dname.name, dname.len);
>> @@ -1969,6 +1970,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>>   			goto retry_lookup;
>>   		}
>>   
>> +		/*
>> +		 * ceph_readdir will use the dentry to get the name
>> +		 * to avoid doing the dencrypt again there.
>> +		 */
>> +		rde->dentry = dget(dn);
>> +
>>   		/* inode */
>>   		if (d_really_is_positive(dn)) {
>>   			in = d_inode(dn);
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index 8d704ddd7291..215a52169a1a 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -733,6 +733,8 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
>>   
>>   		kfree(rde->inode.fscrypt_auth);
>>   		kfree(rde->inode.fscrypt_file);
>> +		dput(rde->dentry);
>> +		rde->dentry = NULL;
>>   	}
>>   	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
>>   }
>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>> index 0dfe24f94567..663d7754d57d 100644
>> --- a/fs/ceph/mds_client.h
>> +++ b/fs/ceph/mds_client.h
>> @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
>>   };
>>   
>>   struct ceph_mds_reply_dir_entry {
>> +	struct dentry		      *dentry;
>>   	char                          *name;
>>   	u8			      *altname;
>>   	u32                           name_len;
> Testing this on top of wip-fscrypt, I hit the new BUG_ON you added
> immediately with xfstest generic/006. I haven't sat down to work out the
> cause though:
>
> [  286.647758] ------------[ cut here ]------------
> [  286.652281] kernel BUG at fs/ceph/dir.c:535!
> [  286.654487] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
> [  286.656188] CPU: 4 PID: 2073 Comm: find Tainted: G            E     5.17.0-rc6+ #170
> [  286.658393] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
> [  286.660775] RIP: 0010:ceph_readdir+0x1271/0x1d90 [ceph]
> [  286.662412] Code: 25 c8 48 8b 95 d0 fa ff ff 4d 89 e9 45 89 f0 4c 89 f9 48 c7 c6 00 76 32 c1 48 c7 c7 b0 ec 38 c1 e8 c4 10 6d c8 e9 b8 fb ff ff <0f> 0b 48 89 ea b9 02 00 00 00 48 c1 ea 20 89 d0 31 e8 39 d5 0f 44
> [  286.667755] RSP: 0018:ffff8881156ffce0 EFLAGS: 00010246
> [  286.669225] RAX: 0000000000000000 RBX: ffff8881648b5e50 RCX: ffffffffc12d25c1
> [  286.671209] RDX: dffffc0000000000 RSI: ffffffff8a40007c RDI: ffff8881648b5e50
> [  286.673269] RBP: 0000000000000000 R08: ffffffffc12d2523 R09: 0000000000000000
> [  286.675577] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8881156ffeb0
> [  286.677013] R13: ffff8881156ffeb8 R14: ffff8881648b5e78 R15: 0ff7caa620000002
> [  286.678277] FS:  00007fb446008800(0000) GS:ffff88841d400000(0000) knlGS:0000000000000000
> [  286.679781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  286.680800] CR2: 0000564c99ee90e8 CR3: 0000000117e16000 CR4: 00000000003506e0
> [  286.682005] Call Trace:
> [  286.682472]  <TASK>
> [  286.682837]  ? __fdget_pos+0x71/0x80
> [  286.683484]  ? __handle_mm_fault+0x17e0/0x1c20
> [  286.684245]  ? ceph_d_revalidate+0x7e0/0x7e0 [ceph]
> [  286.685265]  ? down_write_killable+0xc7/0x130
> [  286.686202]  ? __down_interruptible+0x1d0/0x1d0
> [  286.686965]  iterate_dir+0x107/0x2e0
> [  286.687584]  __x64_sys_getdents64+0xe2/0x1b0
> [  286.688360]  ? filldir+0x270/0x270
> [  286.693689]  ? __ia32_sys_getdents+0x1a0/0x1a0
> [  286.698465]  ? lockdep_hardirqs_on_prepare+0x129/0x220
> [  286.703362]  ? syscall_enter_from_user_mode+0x21/0x70
> [  286.708261]  do_syscall_64+0x3b/0x90
> [  286.712819]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  286.717584] RIP: 0033:0x7fb44617afd7
> [  286.722128] Code: 19 fb ff 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 21 0e 12 00 f7 d8 64 89 02 48
> [  286.733041] RSP: 002b:00007ffec9342038 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
> [  286.738408] RAX: ffffffffffffffda RBX: 0000564c99e51380 RCX: 00007fb44617afd7
> [  286.743834] RDX: 0000000000010000 RSI: 0000564c99e51380 RDI: 0000000000000004
> [  286.749041] RBP: 0000564c99e51354 R08: 0000000000000003 R09: 0000000000000001
> [  286.754147] R10: 0000000000000fff R11: 0000000000000293 R12: fffffffffffffe98
> [  286.759581] R13: 0000000000000000 R14: 0000564c99e51350 R15: 00000000000010fe
> [  286.764698]  </TASK>
> [  286.769321] Modules linked in: ceph(E) libceph(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) stp(E) llc(E) ip_set(E) rfkill(E) nf_tables(E) nfnetlink(E) cachefiles(E) fscache(E) netfs(E) sunrpc(E) iTCO_wdt(E) intel_pmc_bxt(E) iTCO_vendor_support(E) intel_rapl_msr(E) joydev(E) i2c_i801(E) virtio_balloon(E) i2c_smbus(E) intel_rapl_common(E) lpc_ich(E) fuse(E) zram(E) ip_tables(E) xfs(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) ghash_clmulni_intel(E) serio_raw(E) virtio_gpu(E) virtio_dma_buf(E) drm_shmem_helper(E) virtio_console(E) drm_kms_helper(E) virtio_net(E) cec(E) virtio_blk(E) net_failover(E) failover(E) drm(E) qemu_fw_cfg(E)
> [  286.811123] ---[ end trace 0000000000000000 ]---
> [  286.826446] RIP: 0010:ceph_readdir+0x1271/0x1d90 [ceph]
> [  286.858765] Code: 25 c8 48 8b 95 d0 fa ff ff 4d 89 e9 45 89 f0 4c 89 f9 48 c7 c6 00 76 32 c1 48 c7 c7 b0 ec 38 c1 e8 c4 10 6d c8 e9 b8 fb ff ff <0f> 0b 48 89 ea b9 02 00 00 00 48 c1 ea 20 89 d0 31 e8 39 d5 0f 44
> [  286.873795] RSP: 0018:ffff8881156ffce0 EFLAGS: 00010246
> [  286.888083] RAX: 0000000000000000 RBX: ffff8881648b5e50 RCX: ffffffffc12d25c1
> [  286.906391] RDX: dffffc0000000000 RSI: ffffffff8a40007c RDI: ffff8881648b5e50
> [  286.922678] RBP: 0000000000000000 R08: ffffffffc12d2523 R09: 0000000000000000
> [  286.938922] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8881156ffeb0
> [  286.954630] R13: ffff8881156ffeb8 R14: ffff8881648b5e78 R15: 0ff7caa620000002
> [  286.970468] FS:  00007fb446008800(0000) GS:ffff88841d400000(0000) knlGS:0000000000000000
> [  286.977032] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  286.990098] CR2: 0000564c99ee90e8 CR3: 0000000117e16000 CR4: 00000000003506e0
>

