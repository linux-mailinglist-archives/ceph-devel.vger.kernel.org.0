Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D18F75A32D8
	for <lists+ceph-devel@lfdr.de>; Sat, 27 Aug 2022 02:00:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239360AbiH0AAu (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 26 Aug 2022 20:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241925AbiH0AAs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 26 Aug 2022 20:00:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11F817C1B7
        for <ceph-devel@vger.kernel.org>; Fri, 26 Aug 2022 17:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661558445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDe9fTxG58kEb8/4/8leD8hQCKRCQcaHcJ615O9V8/c=;
        b=Kt4nNGkqoJdrFha1KNmrDBfbIt512CrYgxNYy01pxo3xOZUkznlo5FXYl8ihUjvA1q3RLO
        IJral0JPI7m1gD0DGrTTxoQo9mhu1+khC11MlO0LMnn/aVVGjP2OHLhHmU4lyp3bTeh4Zm
        izsRVpybOYImR9fEkTj2ZRLFtTrS6Zo=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-571-BqpCWq0RPfSn4zbqMO-1Sw-1; Fri, 26 Aug 2022 20:00:43 -0400
X-MC-Unique: BqpCWq0RPfSn4zbqMO-1Sw-1
Received: by mail-pj1-f69.google.com with SMTP id f16-20020a17090a4a9000b001f234757bbbso1733831pjh.6
        for <ceph-devel@vger.kernel.org>; Fri, 26 Aug 2022 17:00:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=iDe9fTxG58kEb8/4/8leD8hQCKRCQcaHcJ615O9V8/c=;
        b=Ql7E1gTd3TRLP1+G2FmWGiDrHwZIurD41x3QLByxOsWw3+bL6W/9XBtnnmAZzUC3cd
         JWGSnBSWDDCcTlvy5ZC8D4zrkOo8adwI9jIVnIeI9Wv3Gx+NQZ7ndDmcCRr7OEHbzJmf
         tcJAVEmsZ2tSB4DhilVpL4pKGnmGszl5RSiSu8RAYcSzIvdzbWR0KepYXYCJdwYIVmcX
         WvpQ/fhG5BnNJ55vfMKPj7HI1hC8OFUo7pUgJkO9HE8VtVJtSCnDPr+pK+Xi2jVW78Dd
         j4gwb05sR0FKfzYLSmjs7r/tQgkkgzrXUmCzK8mLhoz5WOt9Pt8DZFa0BG16zp/Y+Qlw
         2auw==
X-Gm-Message-State: ACgBeo3hJ/HjLezXN2/hXCR88/wG24yz+mkF5/YP/CpUhT4b9i51gpX8
        59E1YaxA7ucf7VC4unMOtXw5hi8iGD3Adklzroup9MbSUqIRJD2xX61GDHPSlBR8/i6uvUu/nC3
        eVLmKQyJLf6ZLRjQzdoFz5rAJFL4VJbUfPExqaYk2jHSbSdo8SglFwZqbaEVXSui9sZaO4FM=
X-Received: by 2002:a62:6347:0:b0:531:c5a7:b209 with SMTP id x68-20020a626347000000b00531c5a7b209mr6190015pfb.60.1661558442571;
        Fri, 26 Aug 2022 17:00:42 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5lv/Yn4tq2bpDwERlfFqcAKf6cODskOuVvnAy+vW20Nu/wzjAFitgE5qfkAfjhA7VTtU7FkA==
X-Received: by 2002:a62:6347:0:b0:531:c5a7:b209 with SMTP id x68-20020a626347000000b00531c5a7b209mr6189990pfb.60.1661558442231;
        Fri, 26 Aug 2022 17:00:42 -0700 (PDT)
Received: from [10.72.12.34] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a21-20020a170902b59500b001743bf0b51csm2108204pls.96.2022.08.26.17.00.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 17:00:41 -0700 (PDT)
Subject: Re: [PATCH v15 00/29] ceph: remaining patches for fscrypt support
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com
Cc:     lhenriques@suse.de, ceph-devel@vger.kernel.org
References: <20220825133132.153657-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0c704e71-6bcb-e6cd-c98b-974dbc1bf8e3@redhat.com>
Date:   Sat, 27 Aug 2022 08:00:35 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220825133132.153657-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/25/22 9:31 PM, Jeff Layton wrote:
> v15: rebase onto current ceph/testing branch
>       add some missing ceph_osdc_wait_request calls
>
> This patchset represents the remaining patches to add fscrypt support,
> rebased on top of today's "testing" branch.  They're all ceph changes as
> the vfs and fscrypt patches are now merged!
>
> Note that the current ceph-client/wip-fscrypt branch is broken. It's
> still based on v5.19-rc6 and has some missing calls to
> ceph_osdc_wait_request that cause panics. This set fixes that.
>
> These are currently in my ceph-fscrypt branch:
>
>     https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/log/?h=ceph-fscrypt
>
> It would be good to update the wip-fscrypt branch with this pile.
>
> Jeff Layton (19):
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
>    ceph: report STATX_ATTR_ENCRYPTED on encrypted inodes
>
> Luís Henriques (6):
>    ceph: don't allow changing layout on encrypted files/directories
>    ceph: invalidate pages when doing direct/sync writes
>    ceph: add support for encrypted snapshot names
>    ceph: add support for handling encrypted snapshot names
>    ceph: update documentation regarding snapshot naming limitations
>    ceph: prevent snapshots to be created in encrypted locked directories
>
> Xiubo Li (4):
>    ceph: add __ceph_get_caps helper support
>    ceph: add __ceph_sync_read helper support
>    ceph: add object version support for sync read
>    ceph: add truncate size handling support for fscrypt
>
>   Documentation/filesystems/ceph.rst |  10 +
>   fs/ceph/addr.c                     | 164 ++++++++--
>   fs/ceph/caps.c                     | 143 +++++++--
>   fs/ceph/crypto.c                   | 367 +++++++++++++++++++++--
>   fs/ceph/crypto.h                   | 118 +++++++-
>   fs/ceph/dir.c                      |   8 +
>   fs/ceph/file.c                     | 467 +++++++++++++++++++++++++----
>   fs/ceph/inode.c                    | 282 +++++++++++++++--
>   fs/ceph/ioctl.c                    |   4 +
>   fs/ceph/mds_client.c               |   9 +-
>   fs/ceph/mds_client.h               |   2 +
>   fs/ceph/super.c                    |   6 +
>   fs/ceph/super.h                    |  11 +
>   include/linux/ceph/osd_client.h    |   6 +-
>   include/linux/ceph/rados.h         |   4 +
>   net/ceph/osd_client.c              |  32 +-
>   16 files changed, 1454 insertions(+), 179 deletions(-)
>
The xfstests-dev tests passed and have updated the wip-fscrypt branch.

Thanks Jeff!



