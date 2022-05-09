Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF66251FBBE
	for <lists+ceph-devel@lfdr.de>; Mon,  9 May 2022 13:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233436AbiEIL5P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 May 2022 07:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233433AbiEIL5N (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 May 2022 07:57:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 142C516A26A
        for <ceph-devel@vger.kernel.org>; Mon,  9 May 2022 04:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652097198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DFnuVWBKUlAOM9ixtZlQ/Ix8sF3yMfNi1uQg7WAyjek=;
        b=e7C/h6DkgF8pnRou44V+ouXVi/RNkAC5kK1GobYyvj2ClbkD9kLLsi+VIo/6lzqzXTEE0I
        fMyRB1CCiYx2PEJqaqDWmIELygc51DcBysbqqW6hd9oo9WVWXozqp7K8iwWMqIEzBRjVRn
        sUgzCyhBtE4rkXJm38VHIc0EW9Qd7sg=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-662-09enw5khMhm7dYWRKshymg-1; Mon, 09 May 2022 07:53:17 -0400
X-MC-Unique: 09enw5khMhm7dYWRKshymg-1
Received: by mail-pl1-f197.google.com with SMTP id v8-20020a170902b7c800b0015e927ee201so8168129plz.12
        for <ceph-devel@vger.kernel.org>; Mon, 09 May 2022 04:53:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DFnuVWBKUlAOM9ixtZlQ/Ix8sF3yMfNi1uQg7WAyjek=;
        b=2FfD77N0WvQlIQIvnqabwJD20u7oTQO0l9aCTvlRmUbfW4OL+YU3O1sm/vlnxPl2Jx
         raWrhE6cA+0ez/11tszfUnYYIWb2STjEkxA/PgBNfpmwC45zlyftboWkNDqRrRyMw+iZ
         3Qoj55EwEC6EPeUTpatwZ6/i3l+9VD/f4yxMnScCFeaVQcQMaLBv741YaF/l0Arz+iea
         lV8VjY2+T90jZUmjPU7Rk2dGN248R7g9QrAgE3/A0oUcdZ3l8S79A9VEpBDfejv0wiY2
         71koYXnCHHEYHAzIgsJaToMijSe2O7CPg8ADkgWMVk1vZBthSTbFWvP1cP8uFYN28BRG
         XOAg==
X-Gm-Message-State: AOAM5324dwKFWMaG41Rc3K2PIgbzUeebh/E3+4QoHcyYAtaLSc6fUOyO
        c0+oA8ymMcOg5elIy06f8NcAFOBN7BBFql1z0fgnKk43Ni03MMxD0lfQ7JfCq0B7NC99KI8NlyC
        4/YF4DzLODYr4Mp+Qzh3Iyw==
X-Received: by 2002:a17:90b:4ac1:b0:1dc:20c4:6363 with SMTP id mh1-20020a17090b4ac100b001dc20c46363mr25962975pjb.79.1652097195820;
        Mon, 09 May 2022 04:53:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxGQu0i7hUcWRQJN542eAEhfZPJH9Jm9kElio3e1lHTjh0BiH/yJ6QBQxwFo+wV5ovf/VH5IA==
X-Received: by 2002:a17:90b:4ac1:b0:1dc:20c4:6363 with SMTP id mh1-20020a17090b4ac100b001dc20c46363mr25962957pjb.79.1652097195557;
        Mon, 09 May 2022 04:53:15 -0700 (PDT)
Received: from [10.72.12.57] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a1-20020aa78e81000000b0050dc7628137sm8816721pfr.17.2022.05.09.04.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 04:53:14 -0700 (PDT)
Subject: Re: [PATCH v14 00/64] ceph+fscrypt: full support
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     lhenriques@suse.de, idryomov@gmail.com
References: <20220427191314.222867-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <bad2bc12-f97b-fcab-7d0d-764fec1ecee7@redhat.com>
Date:   Mon, 9 May 2022 19:53:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220427191314.222867-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff,

All the patches looks good to me. I saw you have fixed the "[PATCH v14 
58/64]" in the wip-fscrypt branch.

Feel free to add:

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thanks.

-- Xiubo


On 4/28/22 3:12 AM, Jeff Layton wrote:
> Yet another ceph+fscrypt posting. The main changes since v13:
>
> - rebased onto v5.18-rc4 + ceph testing branch patches, fixed up minor
>    merge conflicts, and squashed a few patches together
>
> - squashed in a number of patches from Xiubo to fix issues with
>    truncation handling
>
> - incorporated Luís' patches to encrypt snapshot names
>
> - dropped a patch to export fscrypt's base64 implementation, since Luís'
>    snapshot implementation added a new variant that we need to use.
>
> At this point, I'm mainly waiting on Al to merge this patch into -next
> and eventually into v5.19:
>
>      fs: change test in inode_insert5 for adding to the sb list
>
> Once that's in, it should clear the way for us to start merging the
> rest of the pile (though probably not all at once).
>
> There are also some mysterious failures that have cropped up in testing
> with teuthology, particularly with thrash testing. We'll need to get to
> the bottom of that before we can merge the bulk of these patches.
>
> I've updated the wip-fscrypt branch in the ceph tree with this pile for
> now. Help with testing would be welcome!
>
> Jeff Layton (48):
>    libceph: add spinlock around osd->o_requests
>    libceph: define struct ceph_sparse_extent and add some helpers
>    libceph: add sparse read support to msgr2 crc state machine
>    libceph: add sparse read support to OSD client
>    libceph: support sparse reads on msgr2 secure codepath
>    libceph: add sparse read support to msgr1
>    ceph: add new mount option to enable sparse reads
>    fs: change test in inode_insert5 for adding to the sb list
>    fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_encrypted_size
>    fscrypt: add fscrypt_context_for_new_inode
>    ceph: preallocate inode for ops that may create one
>    ceph: fscrypt_auth handling for ceph
>    ceph: ensure that we accept a new context from MDS for new inodes
>    ceph: add support for fscrypt_auth/fscrypt_file to cap messages
>    ceph: implement -o test_dummy_encryption mount option
>    ceph: decode alternate_name in lease info
>    ceph: add fscrypt ioctls
>    ceph: make ceph_msdc_build_path use ref-walk
>    ceph: add encrypted fname handling to ceph_mdsc_build_path
>    ceph: send altname in MClientRequest
>    ceph: encode encrypted name in dentry release
>    ceph: properly set DCACHE_NOKEY_NAME flag in lookup
>    ceph: set DCACHE_NOKEY_NAME in atomic open
>    ceph: make d_revalidate call fscrypt revalidator for encrypted
>      dentries
>    ceph: add helpers for converting names for userland presentation
>    ceph: add fscrypt support to ceph_fill_trace
>    ceph: create symlinks with encrypted and base64-encoded targets
>    ceph: make ceph_get_name decrypt filenames
>    ceph: add a new ceph.fscrypt.auth vxattr
>    ceph: add some fscrypt guardrails
>    libceph: add CEPH_OSD_OP_ASSERT_VER support
>    ceph: size handling for encrypted inodes in cap updates
>    ceph: fscrypt_file field handling in MClientRequest messages
>    ceph: get file size from fscrypt_file when present in inode traces
>    ceph: handle fscrypt fields in cap messages from MDS
>    ceph: update WARN_ON message to pr_warn
>    ceph: add infrastructure for file encryption and decryption
>    libceph: allow ceph_osdc_new_request to accept a multi-op read
>    ceph: disable fallocate for encrypted inodes
>    ceph: disable copy offload on encrypted inodes
>    ceph: don't use special DIO path for encrypted inodes
>    ceph: align data in pages in ceph_sync_write
>    ceph: add read/modify/write to ceph_sync_write
>    ceph: plumb in decryption during sync reads
>    ceph: add fscrypt decryption support to ceph_netfs_issue_op
>    ceph: set i_blkbits to crypto block size for encrypted inodes
>    ceph: add encryption support to writepage
>    ceph: fscrypt support for writepages
>
> Luís Henriques (7):
>    ceph: add base64 endcoding routines for encrypted names
>    ceph: don't allow changing layout on encrypted files/directories
>    ceph: invalidate pages when doing direct/sync writes
>    ceph: add support for encrypted snapshot names
>    ceph: add support for handling encrypted snapshot names
>    ceph: update documentation regarding snapshot naming limitations
>    ceph: prevent snapshots to be created in encrypted locked directories
>
> Xiubo Li (9):
>    ceph: make the ioctl cmd more readable in debug log
>    ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
>    ceph: pass the request to parse_reply_info_readdir()
>    ceph: add ceph_encode_encrypted_dname() helper
>    ceph: add support to readdir for encrypted filenames
>    ceph: add __ceph_get_caps helper support
>    ceph: add __ceph_sync_read helper support
>    ceph: add object version support for sync read
>    ceph: add truncate size handling support for fscrypt
>
>   Documentation/filesystems/ceph.rst |  10 +
>   fs/ceph/Makefile                   |   1 +
>   fs/ceph/acl.c                      |   4 +-
>   fs/ceph/addr.c                     | 136 ++++--
>   fs/ceph/caps.c                     | 219 ++++++++--
>   fs/ceph/crypto.c                   | 638 +++++++++++++++++++++++++++++
>   fs/ceph/crypto.h                   | 264 ++++++++++++
>   fs/ceph/dir.c                      | 187 +++++++--
>   fs/ceph/export.c                   |  44 +-
>   fs/ceph/file.c                     | 598 ++++++++++++++++++++++-----
>   fs/ceph/inode.c                    | 579 +++++++++++++++++++++++---
>   fs/ceph/ioctl.c                    | 126 +++++-
>   fs/ceph/mds_client.c               | 465 +++++++++++++++++----
>   fs/ceph/mds_client.h               |  24 +-
>   fs/ceph/super.c                    | 107 ++++-
>   fs/ceph/super.h                    |  43 +-
>   fs/ceph/xattr.c                    |  29 ++
>   fs/crypto/fname.c                  |  36 +-
>   fs/crypto/fscrypt_private.h        |   9 +-
>   fs/crypto/hooks.c                  |   6 +-
>   fs/crypto/policy.c                 |  35 +-
>   fs/inode.c                         |  11 +-
>   include/linux/ceph/ceph_fs.h       |  21 +-
>   include/linux/ceph/messenger.h     |  32 ++
>   include/linux/ceph/osd_client.h    |  89 +++-
>   include/linux/ceph/rados.h         |   4 +
>   include/linux/fscrypt.h            |   5 +
>   net/ceph/messenger.c               |   1 +
>   net/ceph/messenger_v1.c            |  98 ++++-
>   net/ceph/messenger_v2.c            | 287 ++++++++++++-
>   net/ceph/osd_client.c              | 306 +++++++++++++-
>   31 files changed, 4009 insertions(+), 405 deletions(-)
>   create mode 100644 fs/ceph/crypto.c
>   create mode 100644 fs/ceph/crypto.h
>

