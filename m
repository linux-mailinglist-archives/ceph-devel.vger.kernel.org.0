Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E244D2FAA
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 14:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232431AbiCINGP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 08:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbiCINGN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 08:06:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE366A7743
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 05:05:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26C2261A0D
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 13:05:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F46C340E8;
        Wed,  9 Mar 2022 13:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646831113;
        bh=SqarrPH7y7JEDYQVKdumA8wz6JUQxgaef9UVsAnrwgA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XSSOALN4z57uAYOhNbst2QTjdygDOmkqp1tF4/cZAujjEIQyg8drGZo3dh5xTLiEW
         6xxNSK+atj1lpTezVmp5tGZDikTrwSVs5Ie0sw9fhSRshysgXNcGrZAZqn8wdLxFeB
         OokJcWqv6v+0aijp1BanSLRdJ3qT8EAmg0GEh4vb3q72uFQxpMTWqnFhUJNq2sPe6B
         6F2lXTjqTxK6AG+Ou/Fw2zNxTn4cDyyu4Wp8QQMVSL1y2w1GKHI/EDfMmXCa0G+Zqr
         zAn6PemhjHfe1qeM4AxqPEfykmo/4/voLF1IFthsIZmwMfdiZUOC7UBoz5Fia/2aYg
         tUa0J5iw4HwSA==
Message-ID: <6fef272c748aa9bf95a27ff9f2a0b9e20662e88d.camel@kernel.org>
Subject: Re: [PATCH v6] ceph: do not dencrypt the dentry name twice for
 readdir
From:   Jeff Layton <jlayton@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, vshankar@redhat.com, lhenriques@suse.de,
        ceph-devel@vger.kernel.org
Date:   Wed, 09 Mar 2022 08:05:11 -0500
In-Reply-To: <20220309122556.46503-1-xiubli@redhat.com>
References: <20220309122556.46503-1-xiubli@redhat.com>
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

On Wed, 2022-03-09 at 20:25 +0800, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For the readdir request the dentries will be pasred and dencrypted
> in ceph_readdir_prepopulate(). And in ceph_readdir() we could just
> get the dentry name from the dentry cache instead of parsing and
> dencrypting them again. This could improve performance.
> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
> 
> V6:
> - Remove CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro and use the NAME_MAX
>   instead, since we are limiting the max length of snapshot name to
>   240, which is NAME_MAX - 2 * sizeof('_') - sizeof(<inode#>).
> 
> V5:
> - fix typo of CEPH_ENCRYPTED_LONG_SNAP_NAME_MAX macro
> - release the rde->dentry in destroy_reply_info
> 
> 
> 
>  fs/ceph/dir.c        | 59 +++++++++++++++++++++-----------------------
>  fs/ceph/inode.c      |  7 ++++++
>  fs/ceph/mds_client.c |  2 ++
>  fs/ceph/mds_client.h |  1 +
>  4 files changed, 38 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
> index 6df2a91af236..19321a1f7399 100644
> --- a/fs/ceph/dir.c
> +++ b/fs/ceph/dir.c
> @@ -316,8 +316,7 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	int err;
>  	unsigned frag = -1;
>  	struct ceph_mds_reply_info_parsed *rinfo;
> -	struct fscrypt_str tname = FSTR_INIT(NULL, 0);
> -	struct fscrypt_str oname = FSTR_INIT(NULL, 0);
> +	char *dentry_name = NULL;
>  
>  	dout("readdir %p file %p pos %llx\n", inode, file, ctx->pos);
>  	if (dfi->file_info.flags & CEPH_F_ATEND)
> @@ -369,14 +368,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  		spin_unlock(&ci->i_ceph_lock);
>  	}
>  
> -	err = ceph_fname_alloc_buffer(inode, &tname);
> -	if (err < 0)
> -		goto out;
> -
> -	err = ceph_fname_alloc_buffer(inode, &oname);
> -	if (err < 0)
> -		goto out;
> -
>  	/* proceed with a normal readdir */
>  more:
>  	/* do we have the correct frag content buffered? */
> @@ -528,31 +519,39 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  			}
>  		}
>  	}
> +
> +	dentry_name = kmalloc(NAME_MAX, GFP_KERNEL);
> +	if (!dentry_name) {
> +		err = -ENOMEM;
> +		ceph_mdsc_put_request(dfi->last_readdir);
> +		dfi->last_readdir = NULL;
> +		goto out;
> +	}
> +
>  	for (; i < rinfo->dir_nr; i++) {
>  		struct ceph_mds_reply_dir_entry *rde = rinfo->dir_entries + i;
> -		struct ceph_fname fname = { .dir	= inode,
> -					    .name	= rde->name,
> -					    .name_len	= rde->name_len,
> -					    .ctext	= rde->altname,
> -					    .ctext_len	= rde->altname_len };
> -		u32 olen = oname.len;
> -
> -		err = ceph_fname_to_usr(&fname, &tname, &oname, NULL);
> -		if (err) {
> -			pr_err("%s unable to decode %.*s, got %d\n", __func__,
> -			       rde->name_len, rde->name, err);
> -			goto out;
> -		}
> +		struct dentry *dn = rde->dentry;
> +		int name_len;
>  
>  		BUG_ON(rde->offset < ctx->pos);
>  		BUG_ON(!rde->inode.in);
> +		BUG_ON(!rde->dentry);
>  
>  		ctx->pos = rde->offset;
> -		dout("readdir (%d/%d) -> %llx '%.*s' %p\n",
> -		     i, rinfo->dir_nr, ctx->pos,
> -		     rde->name_len, rde->name, &rde->inode.in);
>  
> -		if (!dir_emit(ctx, oname.name, oname.len,
> +		spin_lock(&dn->d_lock);
> +		memcpy(dentry_name, dn->d_name.name, dn->d_name.len);
> +		name_len = dn->d_name.len;
> +		spin_unlock(&dn->d_lock);
> +
> +		dentry_name[name_len] = '\0';
> +		dout("readdir (%d/%d) -> %llx '%s' %p\n",
> +		     i, rinfo->dir_nr, ctx->pos, dentry_name, &rde->inode.in);
> +
> +		dput(dn);
> +		rde->dentry = NULL;
> +
> +		if (!dir_emit(ctx, dentry_name, name_len,
>  			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
>  			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
>  			/*
> @@ -566,8 +565,6 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  			goto out;
>  		}
>  
> -		/* Reset the lengths to their original allocated vals */
> -		oname.len = olen;
>  		ctx->pos++;
>  	}
>  
> @@ -625,8 +622,8 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
>  	err = 0;
>  	dout("readdir %p file %p done.\n", inode, file);
>  out:
> -	ceph_fname_free_buffer(inode, &tname);
> -	ceph_fname_free_buffer(inode, &oname);
> +	if (dentry_name)
> +		kfree(dentry_name);
>  	return err;
>  }
>  
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index b573a0f33450..19e5275eae1c 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -1909,6 +1909,7 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  			goto out;
>  		}
>  
> +		rde->dentry = NULL;
>  		dname.name = oname.name;
>  		dname.len = oname.len;
>  		dname.hash = full_name_hash(parent, dname.name, dname.len);
> @@ -1969,6 +1970,12 @@ int ceph_readdir_prepopulate(struct ceph_mds_request *req,
>  			goto retry_lookup;
>  		}
>  
> +		/*
> +		 * ceph_readdir will use the dentry to get the name
> +		 * to avoid doing the dencrypt again there.
> +		 */
> +		rde->dentry = dget(dn);
> +
>  		/* inode */
>  		if (d_really_is_positive(dn)) {
>  			in = d_inode(dn);
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 8d704ddd7291..215a52169a1a 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -733,6 +733,8 @@ static void destroy_reply_info(struct ceph_mds_reply_info_parsed *info)
>  
>  		kfree(rde->inode.fscrypt_auth);
>  		kfree(rde->inode.fscrypt_file);
> +		dput(rde->dentry);
> +		rde->dentry = NULL;
>  	}
>  	free_pages((unsigned long)info->dir_entries, get_order(info->dir_buf_size));
>  }
> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
> index 0dfe24f94567..663d7754d57d 100644
> --- a/fs/ceph/mds_client.h
> +++ b/fs/ceph/mds_client.h
> @@ -96,6 +96,7 @@ struct ceph_mds_reply_info_in {
>  };
>  
>  struct ceph_mds_reply_dir_entry {
> +	struct dentry		      *dentry;
>  	char                          *name;
>  	u8			      *altname;
>  	u32                           name_len;

Testing this on top of wip-fscrypt, I hit the new BUG_ON you added
immediately with xfstest generic/006. I haven't sat down to work out the
cause though:

[  286.647758] ------------[ cut here ]------------
[  286.652281] kernel BUG at fs/ceph/dir.c:535!
[  286.654487] invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
[  286.656188] CPU: 4 PID: 2073 Comm: find Tainted: G            E     5.17.0-rc6+ #170
[  286.658393] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1.fc35 04/01/2014
[  286.660775] RIP: 0010:ceph_readdir+0x1271/0x1d90 [ceph]
[  286.662412] Code: 25 c8 48 8b 95 d0 fa ff ff 4d 89 e9 45 89 f0 4c 89 f9 48 c7 c6 00 76 32 c1 48 c7 c7 b0 ec 38 c1 e8 c4 10 6d c8 e9 b8 fb ff ff <0f> 0b 48 89 ea b9 02 00 00 00 48 c1 ea 20 89 d0 31 e8 39 d5 0f 44
[  286.667755] RSP: 0018:ffff8881156ffce0 EFLAGS: 00010246
[  286.669225] RAX: 0000000000000000 RBX: ffff8881648b5e50 RCX: ffffffffc12d25c1
[  286.671209] RDX: dffffc0000000000 RSI: ffffffff8a40007c RDI: ffff8881648b5e50
[  286.673269] RBP: 0000000000000000 R08: ffffffffc12d2523 R09: 0000000000000000
[  286.675577] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8881156ffeb0
[  286.677013] R13: ffff8881156ffeb8 R14: ffff8881648b5e78 R15: 0ff7caa620000002
[  286.678277] FS:  00007fb446008800(0000) GS:ffff88841d400000(0000) knlGS:0000000000000000
[  286.679781] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  286.680800] CR2: 0000564c99ee90e8 CR3: 0000000117e16000 CR4: 00000000003506e0
[  286.682005] Call Trace:
[  286.682472]  <TASK>
[  286.682837]  ? __fdget_pos+0x71/0x80
[  286.683484]  ? __handle_mm_fault+0x17e0/0x1c20
[  286.684245]  ? ceph_d_revalidate+0x7e0/0x7e0 [ceph]
[  286.685265]  ? down_write_killable+0xc7/0x130
[  286.686202]  ? __down_interruptible+0x1d0/0x1d0
[  286.686965]  iterate_dir+0x107/0x2e0
[  286.687584]  __x64_sys_getdents64+0xe2/0x1b0
[  286.688360]  ? filldir+0x270/0x270
[  286.693689]  ? __ia32_sys_getdents+0x1a0/0x1a0
[  286.698465]  ? lockdep_hardirqs_on_prepare+0x129/0x220
[  286.703362]  ? syscall_enter_from_user_mode+0x21/0x70
[  286.708261]  do_syscall_64+0x3b/0x90
[  286.712819]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  286.717584] RIP: 0033:0x7fb44617afd7
[  286.722128] Code: 19 fb ff 4c 89 e0 5b 5d 41 5c c3 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8 ff ff ff 7f 48 39 c2 48 0f 47 d0 b8 d9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 8b 15 21 0e 12 00 f7 d8 64 89 02 48
[  286.733041] RSP: 002b:00007ffec9342038 EFLAGS: 00000293 ORIG_RAX: 00000000000000d9
[  286.738408] RAX: ffffffffffffffda RBX: 0000564c99e51380 RCX: 00007fb44617afd7
[  286.743834] RDX: 0000000000010000 RSI: 0000564c99e51380 RDI: 0000000000000004
[  286.749041] RBP: 0000564c99e51354 R08: 0000000000000003 R09: 0000000000000001
[  286.754147] R10: 0000000000000fff R11: 0000000000000293 R12: fffffffffffffe98
[  286.759581] R13: 0000000000000000 R14: 0000564c99e51350 R15: 00000000000010fe
[  286.764698]  </TASK>
[  286.769321] Modules linked in: ceph(E) libceph(E) nft_fib_inet(E) nft_fib_ipv4(E) nft_fib_ipv6(E) nft_fib(E) nft_reject_inet(E) nf_reject_ipv4(E) nf_reject_ipv6(E) nft_reject(E) nft_ct(E) nft_chain_nat(E) nf_nat(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) bridge(E) stp(E) llc(E) ip_set(E) rfkill(E) nf_tables(E) nfnetlink(E) cachefiles(E) fscache(E) netfs(E) sunrpc(E) iTCO_wdt(E) intel_pmc_bxt(E) iTCO_vendor_support(E) intel_rapl_msr(E) joydev(E) i2c_i801(E) virtio_balloon(E) i2c_smbus(E) intel_rapl_common(E) lpc_ich(E) fuse(E) zram(E) ip_tables(E) xfs(E) crct10dif_pclmul(E) crc32_pclmul(E) crc32c_intel(E) ghash_clmulni_intel(E) serio_raw(E) virtio_gpu(E) virtio_dma_buf(E) drm_shmem_helper(E) virtio_console(E) drm_kms_helper(E) virtio_net(E) cec(E) virtio_blk(E) net_failover(E) failover(E) drm(E) qemu_fw_cfg(E)
[  286.811123] ---[ end trace 0000000000000000 ]---
[  286.826446] RIP: 0010:ceph_readdir+0x1271/0x1d90 [ceph]
[  286.858765] Code: 25 c8 48 8b 95 d0 fa ff ff 4d 89 e9 45 89 f0 4c 89 f9 48 c7 c6 00 76 32 c1 48 c7 c7 b0 ec 38 c1 e8 c4 10 6d c8 e9 b8 fb ff ff <0f> 0b 48 89 ea b9 02 00 00 00 48 c1 ea 20 89 d0 31 e8 39 d5 0f 44
[  286.873795] RSP: 0018:ffff8881156ffce0 EFLAGS: 00010246
[  286.888083] RAX: 0000000000000000 RBX: ffff8881648b5e50 RCX: ffffffffc12d25c1
[  286.906391] RDX: dffffc0000000000 RSI: ffffffff8a40007c RDI: ffff8881648b5e50
[  286.922678] RBP: 0000000000000000 R08: ffffffffc12d2523 R09: 0000000000000000
[  286.938922] R10: 0000000000000001 R11: 0000000000000001 R12: ffff8881156ffeb0
[  286.954630] R13: ffff8881156ffeb8 R14: ffff8881648b5e78 R15: 0ff7caa620000002
[  286.970468] FS:  00007fb446008800(0000) GS:ffff88841d400000(0000) knlGS:0000000000000000
[  286.977032] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  286.990098] CR2: 0000564c99ee90e8 CR3: 0000000117e16000 CR4: 00000000003506e0

-- 
Jeff Layton <jlayton@kernel.org>
