Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E96A14E4124
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Mar 2022 15:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236919AbiCVO1j (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Mar 2022 10:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239089AbiCVOYJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 22 Mar 2022 10:24:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C1C79680C;
        Tue, 22 Mar 2022 07:18:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF25DB81CFB;
        Tue, 22 Mar 2022 14:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0487C340EC;
        Tue, 22 Mar 2022 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647958677;
        bh=JT3rA4cLXpfNW+UPJHsaxbs1Pwr25W016ZWRI5J2G54=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P05vpoklm0tIoseDYhzwaVq/5j+HnwgVnDex3IuwuWWKuSJpvW8aJE/+1FYk8ufZw
         XCUFps7s9cp9xmh43Q6/jT3/AO1XGobv3jI8SJGv9oa4gxQkaGpafBypMgxMDlvPPB
         +DximDonRRZ2DU9WGUyZrsbpkkDSlT749epoKOEvN/7UCizn8cdm1CfQzPu59cSLUf
         PHHf9Mi2/ZZ2DKB3k7uctGjXQbZlf8wDUESinCxyiq2tlTkF/SaIxnSs5oquZQwFEv
         2YBwM989vibJkF5aSJ6gB82C/JxN9cYTs3pNON4BotvPBtPv+rv3lcCiwyFP5/BHKz
         5OmVtHCs56aFA==
Message-ID: <5d43feb5668de88a3667e88e72a3168b299a6533.camel@kernel.org>
Subject: Re: [RFC PATCH v11 00/51] ceph+fscrypt : full support
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        lhenriques@suse.de
Date:   Tue, 22 Mar 2022 10:17:55 -0400
In-Reply-To: <20220322141316.41325-1-jlayton@kernel.org>
References: <20220322141316.41325-1-jlayton@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-03-22 at 10:12 -0400, Jeff Layton wrote:
> This patchset represents a (mostly) working prototype of the
> ceph+fscrypt work. With this, I'm able run xfstests with
> test_dummy_encryption, and most of the tests that pass on ceph without
> fscrypt now pass on it.
> 
> When I made the last posting of this series [1], I mentioned that proper
> support for sparse read support would be necessary to do this. Thus, the
> biggest difference from the v10 set is that this is now based on top of
> the patch series that I posted yesterday to implement sparse reads [2].
> 
> Aside from that, there are also numerous cleanups all over the tree, as
> well as an overhaul of the readdir handling by Xiubo.
> 
> This series is not yet bug-free, but it's at a point where it is quite
> usable, providing you're running against the Quincy release of ceph
> (which should ship sometime in the next few months).
> 
> Next Steps:
> ===========
> I'm not going to sugar-coat it. This is a huge, invasive patch series
> that touches a lot of the most sensitive code in ceph.
> 
> Eric Biggers has acked the changes we need in fscrypt infrastructure. I
> still need Al to ack exporting the new_inode_pseudo symbol. The rest is
> pretty much all ceph and libceph code.
> 
> The main piece missing at this point is support for sparse reads with
> ms_mode settings other than "crc". Once that's complete, I want to merge
> that and this series into the ceph "testing" branch so we can start
> running tests against it in teuthology with fscrypt enabled.
> 
> If that goes well, I think we could probably merge this into mainline
> for v5.20 or v5.21. There is also some incoming support for netfs write
> and DIO read helpers that we may want to convert to as well [3]. That
> may alter the timing as well.
> 
> Review, comments and questions are welcome...
> 
> [1]: https://lore.kernel.org/ceph-devel/20220111191608.88762-1-jlayton@kernel.org/
> 
> [2]: https://lore.kernel.org/ceph-devel/20220318135013.43934-1-jlayton@kernel.org/
> 
> [3]: https://lore.kernel.org/ceph-devel/YixWLJXyWtD+STvl@codewreck.org/T/#maec7e3579f13a45171ad23d7a49183d169fcfcca
> 
> Jeff Layton (41):
>   vfs: export new_inode_pseudo
>   fscrypt: export fscrypt_base64url_encode and fscrypt_base64url_decode
>   fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_encrypted_size
>   fscrypt: add fscrypt_context_for_new_inode
>   ceph: preallocate inode for ops that may create one
>   ceph: crypto context handling for ceph
>   ceph: parse new fscrypt_auth and fscrypt_file fields in inode traces
>   ceph: add support for fscrypt_auth/fscrypt_file to cap messages
>   ceph: add ability to set fscrypt_auth via setattr
>   ceph: implement -o test_dummy_encryption mount option
>   ceph: decode alternate_name in lease info
>   ceph: add fscrypt ioctls
>   ceph: make ceph_msdc_build_path use ref-walk
>   ceph: add encrypted fname handling to ceph_mdsc_build_path
>   ceph: send altname in MClientRequest
>   ceph: encode encrypted name in dentry release
>   ceph: properly set DCACHE_NOKEY_NAME flag in lookup
>   ceph: make d_revalidate call fscrypt revalidator for encrypted
>     dentries
>   ceph: add helpers for converting names for userland presentation
>   ceph: add fscrypt support to ceph_fill_trace
>   ceph: create symlinks with encrypted and base64-encoded targets
>   ceph: make ceph_get_name decrypt filenames
>   ceph: add a new ceph.fscrypt.auth vxattr
>   ceph: add some fscrypt guardrails
>   libceph: add CEPH_OSD_OP_ASSERT_VER support
>   ceph: size handling for encrypted inodes in cap updates
>   ceph: fscrypt_file field handling in MClientRequest messages
>   ceph: get file size from fscrypt_file when present in inode traces
>   ceph: handle fscrypt fields in cap messages from MDS
>   ceph: add infrastructure for file encryption and decryption
>   libceph: allow ceph_osdc_new_request to accept a multi-op read
>   ceph: disable fallocate for encrypted inodes
>   ceph: disable copy offload on encrypted inodes
>   ceph: don't use special DIO path for encrypted inodes
>   ceph: align data in pages in ceph_sync_write
>   ceph: add read/modify/write to ceph_sync_write
>   ceph: plumb in decryption during sync reads
>   ceph: add fscrypt decryption support to ceph_netfs_issue_op
>   ceph: set i_blkbits to crypto block size for encrypted inodes
>   ceph: add encryption support to writepage
>   ceph: fscrypt support for writepages
> 
> Luis Henriques (1):
>   ceph: don't allow changing layout on encrypted files/directories
> 
> Xiubo Li (9):
>   ceph: make the ioctl cmd more readable in debug log
>   ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
>   ceph: pass the request to parse_reply_info_readdir()
>   ceph: add ceph_encode_encrypted_dname() helper
>   ceph: add support to readdir for encrypted filenames
>   ceph: add __ceph_get_caps helper support
>   ceph: add __ceph_sync_read helper support
>   ceph: add object version support for sync read
>   ceph: add truncate size handling support for fscrypt
> 
>  fs/ceph/Makefile                |   1 +
>  fs/ceph/acl.c                   |   4 +-
>  fs/ceph/addr.c                  | 128 ++++++--
>  fs/ceph/caps.c                  | 212 +++++++++++--
>  fs/ceph/crypto.c                | 432 +++++++++++++++++++++++++
>  fs/ceph/crypto.h                | 256 +++++++++++++++
>  fs/ceph/dir.c                   | 182 ++++++++---
>  fs/ceph/export.c                |  44 ++-
>  fs/ceph/file.c                  | 530 ++++++++++++++++++++++++++-----
>  fs/ceph/inode.c                 | 546 +++++++++++++++++++++++++++++---
>  fs/ceph/ioctl.c                 | 126 +++++++-
>  fs/ceph/mds_client.c            | 455 ++++++++++++++++++++++----
>  fs/ceph/mds_client.h            |  24 +-
>  fs/ceph/super.c                 |  91 +++++-
>  fs/ceph/super.h                 |  43 ++-
>  fs/ceph/xattr.c                 |  29 ++
>  fs/crypto/fname.c               |  44 ++-
>  fs/crypto/fscrypt_private.h     |   9 +-
>  fs/crypto/hooks.c               |   6 +-
>  fs/crypto/policy.c              |  35 +-
>  fs/inode.c                      |   1 +
>  include/linux/ceph/ceph_fs.h    |  21 +-
>  include/linux/ceph/osd_client.h |   6 +-
>  include/linux/ceph/rados.h      |   4 +
>  include/linux/fscrypt.h         |  10 +
>  net/ceph/osd_client.c           |  32 +-
>  26 files changed, 2907 insertions(+), 364 deletions(-)
>  create mode 100644 fs/ceph/crypto.c
>  create mode 100644 fs/ceph/crypto.h
> 

I'm going to go ahead and update the wip-fscrypt branch in the ceph
kernel tree to use this series. Please note that for now, that branch
won't work correctly when the ms_mode=secure or ms_mode=legacy transport
modes are used.

Once the sparse read support is updated to include those, we should be
able to use other transports with it.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>
