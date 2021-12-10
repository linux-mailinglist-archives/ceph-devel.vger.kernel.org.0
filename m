Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD3D46F954
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Dec 2021 03:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236140AbhLJCuv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Dec 2021 21:50:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231175AbhLJCuu (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Dec 2021 21:50:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639104436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RDm182yzFAowpD6q2G/7EZAzbuAuDW5mdyX19r8/gMM=;
        b=h77LQSK4NyUuQv+B75x/OGdHpTSG5cY7/qmTdglSzgfeOunghDoDMtv43rIK4wC+sjonEz
        NKfrgLuCkwpB4Nlf/rS2+9PMEq9kCAIxNOEWZQQPbePMqeJAYdsZ1qR8bT0kW2jDwQNCzb
        rgSZDPKMirSVw7eNMsOhjXkYxgjBIDg=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-a93DIqweNpSBLWJsEsquNg-1; Thu, 09 Dec 2021 21:47:15 -0500
X-MC-Unique: a93DIqweNpSBLWJsEsquNg-1
Received: by mail-pj1-f71.google.com with SMTP id h15-20020a17090a648f00b001a96c2c97abso4789209pjj.9
        for <ceph-devel@vger.kernel.org>; Thu, 09 Dec 2021 18:47:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RDm182yzFAowpD6q2G/7EZAzbuAuDW5mdyX19r8/gMM=;
        b=4LnONBbCS7iW7hhYkiVQWCmpgK+sMIWE2ixBfeu/1n9ft3MgWB+NR9mrOVIEhacni6
         3A+ae788TtoxccDIqwJSOgX0ve5AenXHqZ1iBVXcWSU3mBg7V3hMq+UGwdHcbXfOuy/m
         2bt0puwnQOE97Z+oB75iPti4FuGOLC8z7kNFbNYGPwMRjLbVOZ+DzStkwq0CcqvtK77I
         LPUEnGihz4GT+ofKKJxQWGLe4Uy9ANh9STZ3lfS+Q9Ce2fDqK6XDe8fUdA7oSvjUehlm
         HKezWly7QqHqFOflsizxkX1GDukBVZ0Qa2qqBXKrhXRzgmG4UNlyHV+n1wl8Yn3/y6W2
         oclA==
X-Gm-Message-State: AOAM5322OyF3yNHpgDrwYSbRQixh7jkQf9/9kQ9otWeQ2knpqneqAx/c
        aAQ+XXltPOiZrV5ijdy22sg2GrFtBU8U4mPrbkihdlcKAbS7Avxc4rzvzu1tzlwHf9ujTX3krQI
        nLOSEeb791oHKGLX3y0gVHg==
X-Received: by 2002:a05:6a00:198c:b0:4a4:e75f:75cb with SMTP id d12-20020a056a00198c00b004a4e75f75cbmr15618768pfl.38.1639104433917;
        Thu, 09 Dec 2021 18:47:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwpnkhqww19Tpc25FVHBxUWJf656rgeAQdK4L58xNriGevdZKOt+HYqZaRBDAUpzaz55t0Dyg==
X-Received: by 2002:a05:6a00:198c:b0:4a4:e75f:75cb with SMTP id d12-20020a056a00198c00b004a4e75f75cbmr15618757pfl.38.1639104433686;
        Thu, 09 Dec 2021 18:47:13 -0800 (PST)
Received: from [10.72.12.129] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t186sm1029523pfc.122.2021.12.09.18.47.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 18:47:12 -0800 (PST)
Subject: Re: [PATCH 00/36] ceph+fscrypt: context, filename, symlink and size
 handling support
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20211209153647.58953-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <c5947b29-e209-e98e-ec21-875ff8592bfb@redhat.com>
Date:   Fri, 10 Dec 2021 10:47:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211209153647.58953-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 12/9/21 11:36 PM, Jeff Layton wrote:
> I've not posted this in a while, so I figured it was a good time to do
> so. This patchset is a pile of the mostly settled parts of the fscrypt
> integration series. With this, pretty much everything but the actual
> content encryption in files now works.
>
> This series is also in the wip-fscrypt-size branch of the ceph-client
> tree:
>
>      https://github.com/ceph/ceph-client/tree/wip-fscrypt-size
>
> It would also be nice to have an ack from Al Viro on patch #1, and from
> Eric Biggers on #2-5. Those touch code outside of the ceph parts. If
> they aren't acceptable for some reason, I'll need to find other ways to
> handle them.
>
> Jeff Layton (31):
>    vfs: export new_inode_pseudo
>    fscrypt: export fscrypt_base64url_encode and fscrypt_base64url_decode
>    fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_encrypted_size
>    fscrypt: add fscrypt_context_for_new_inode
>    fscrypt: uninline and export fscrypt_require_key
>    ceph: preallocate inode for ops that may create one
>    ceph: crypto context handling for ceph
>    ceph: parse new fscrypt_auth and fscrypt_file fields in inode traces
>    ceph: add fscrypt_* handling to caps.c
>    ceph: add ability to set fscrypt_auth via setattr
>    ceph: implement -o test_dummy_encryption mount option
>    ceph: decode alternate_name in lease info
>    ceph: add fscrypt ioctls
>    ceph: make ceph_msdc_build_path use ref-walk
>    ceph: add encrypted fname handling to ceph_mdsc_build_path
>    ceph: send altname in MClientRequest
>    ceph: encode encrypted name in dentry release
>    ceph: properly set DCACHE_NOKEY_NAME flag in lookup
>    ceph: make d_revalidate call fscrypt revalidator for encrypted
>      dentries
>    ceph: add helpers for converting names for userland presentation
>    ceph: add fscrypt support to ceph_fill_trace
>    ceph: add support to readdir for encrypted filenames
>    ceph: create symlinks with encrypted and base64-encoded targets
>    ceph: make ceph_get_name decrypt filenames
>    ceph: add a new ceph.fscrypt.auth vxattr
>    ceph: add some fscrypt guardrails
>    libceph: add CEPH_OSD_OP_ASSERT_VER support
>    ceph: size handling for encrypted inodes in cap updates
>    ceph: fscrypt_file field handling in MClientRequest messages
>    ceph: get file size from fscrypt_file when present in inode traces
>    ceph: handle fscrypt fields in cap messages from MDS
>
> Luis Henriques (1):
>    ceph: don't allow changing layout on encrypted files/directories
>
> Xiubo Li (4):
>    ceph: add __ceph_get_caps helper support
>    ceph: add __ceph_sync_read helper support
>    ceph: add object version support for sync read
>    ceph: add truncate size handling support for fscrypt
>
>   fs/ceph/Makefile                |   1 +
>   fs/ceph/acl.c                   |   4 +-
>   fs/ceph/caps.c                  | 211 ++++++++++--
>   fs/ceph/crypto.c                | 253 ++++++++++++++
>   fs/ceph/crypto.h                | 154 +++++++++
>   fs/ceph/dir.c                   | 209 +++++++++---
>   fs/ceph/export.c                |  44 ++-
>   fs/ceph/file.c                  | 125 ++++---
>   fs/ceph/inode.c                 | 566 +++++++++++++++++++++++++++++---
>   fs/ceph/ioctl.c                 |  87 +++++
>   fs/ceph/mds_client.c            | 349 +++++++++++++++++---
>   fs/ceph/mds_client.h            |  24 +-
>   fs/ceph/super.c                 |  82 ++++-
>   fs/ceph/super.h                 |  42 ++-
>   fs/ceph/xattr.c                 |  29 ++
>   fs/crypto/fname.c               |  40 ++-
>   fs/crypto/fscrypt_private.h     |  35 +-
>   fs/crypto/hooks.c               |   6 +-
>   fs/crypto/keysetup.c            |  27 ++
>   fs/crypto/policy.c              |  34 +-
>   fs/inode.c                      |   1 +
>   include/linux/ceph/ceph_fs.h    |  21 +-
>   include/linux/ceph/osd_client.h |   6 +-
>   include/linux/ceph/rados.h      |   4 +
>   include/linux/fscrypt.h         |  15 +
>   net/ceph/osd_client.c           |   5 +
>   26 files changed, 2087 insertions(+), 287 deletions(-)
>   create mode 100644 fs/ceph/crypto.c
>   create mode 100644 fs/ceph/crypto.h
>
I have test this series together with ceph side PR#1 and worked well for 
me. LGTM.

1), https://github.com/ceph/ceph/pull/43588


Reviewed-by: Xiubo Li <xiubli@redhat.com>

BRs


