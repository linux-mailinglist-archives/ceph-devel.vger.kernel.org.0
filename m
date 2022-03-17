Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE034DBED4
	for <lists+ceph-devel@lfdr.de>; Thu, 17 Mar 2022 06:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiCQF6K (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 17 Mar 2022 01:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiCQF6J (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 17 Mar 2022 01:58:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB07710CF10
        for <ceph-devel@vger.kernel.org>; Wed, 16 Mar 2022 22:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647494830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tv87CG7LG3XKpxDNEZ+GwPodON4sdnWxi1QyglUUWzI=;
        b=SGBqu+Foh3O8/2PUh5QoWuDzCPM8RuJqVswr2pOfg96xH8Y30oCUpeLqS5uw9t7SRTTgmk
        4v63uF5q+SMajRy10ir7E7618bP1V5fkXSkkbzhDWdUdQozzHKkAdFQVV5Dg6FwNV3tBvI
        YmkONhUWkPFDkZ/Sz8aeKhCbyueOAlc=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-124-lln9ambkMuqq53tTRRGIaA-1; Thu, 17 Mar 2022 01:27:09 -0400
X-MC-Unique: lln9ambkMuqq53tTRRGIaA-1
Received: by mail-pj1-f71.google.com with SMTP id q21-20020a17090a2e1500b001c44f70fd38so2771888pjd.6
        for <ceph-devel@vger.kernel.org>; Wed, 16 Mar 2022 22:27:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tv87CG7LG3XKpxDNEZ+GwPodON4sdnWxi1QyglUUWzI=;
        b=cIbNRnUhjLFPuIFH5NyvXBsyS2i8GylubNptKAAIjJGZ5CUcZZJQIyM4R0fa1lt2F4
         u81YLTGghDNHGcOMbLE9GINDgvSoQ2cCuTbkWWML63MOmiSM5olAUwiO5DfjQ+hSgkvw
         Q8Xd9yyrkTyAQ6/0ee3h8kSL0keXeZDzKxr1J5zx7+L4U+Al8VCzvFtC324XF5DMNNa4
         tDzn8/Ouyii0quJ8sR5pP6l3uZYKdUnV1uWkk5MJs2l2LIJZ9flxV5G+MVoDHq+fe0Bv
         IPkVUhlbe4/2BcM6V/Y5NSGFgx/8asQ8f1Rv2R+n1MmqO4fhbA0x2R2Jxm/F4tUA/lYS
         +NYA==
X-Gm-Message-State: AOAM531zjbtmA2rAziL2QKn5QdNMiIrWawG3D6NQ1jOhe4a2zlVX/HYG
        rMaI5D8UigL9Q/JSs0uL7NBW1cjEyGvQUYBZN6CGovTzHsQeUi4qK0NrzYUc4Am4MAPxYqYduHq
        LOPU+YJb+QTQoC8ZKM9NTKg==
X-Received: by 2002:a17:902:ce8a:b0:153:191:b24e with SMTP id f10-20020a170902ce8a00b001530191b24emr3011980plg.135.1647494827971;
        Wed, 16 Mar 2022 22:27:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznSB+E+HfjEDlJ6+UMu/rrJfeYA0TD89epzRt55YVmSkSlYTG5o0vA572uSkle0tFT0sPMlw==
X-Received: by 2002:a17:902:ce8a:b0:153:191:b24e with SMTP id f10-20020a170902ce8a00b001530191b24emr3011963plg.135.1647494827705;
        Wed, 16 Mar 2022 22:27:07 -0700 (PDT)
Received: from [10.72.12.110] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r4-20020a638f44000000b0038105776895sm4160156pgn.76.2022.03.16.22.27.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 22:27:07 -0700 (PDT)
Subject: Re: [RFC PATCH v2 0/3] ceph: add support for snapshot names
 encryption
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
References: <20220315161959.19453-1-lhenriques@suse.de>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <5b53e812-d49b-45f0-1219-3dbc96febbc1@redhat.com>
Date:   Thu, 17 Mar 2022 13:27:01 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220315161959.19453-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Luis,

There has another issue you need to handle at the same time.

Currently only the empty directory could be enabled the file encryption, 
such as for the following command:

$ fscrypt encrypt mydir/

But should we also make sure that the mydir/.snap/ is empty ?

Here the 'empty' is not totally empty, which allows it should allow long 
snap names exist.

Make sense ?

- Xiubo


On 3/16/22 12:19 AM, Luís Henriques wrote:
> Hi!
>
> A couple of changes since v1:
>
> - Dropped the dentry->d_flags change in ceph_mkdir().  Thanks to Xiubo
>    suggestion, patch 0001 now skips calling ceph_fscrypt_prepare_context()
>    if we're handling a snapshot.
>
> - Added error handling to ceph_get_snapdir() in patch 0001 (Jeff had
>    already pointed that out but I forgot to include that change in previous
>    revision).
>
> - Rebased patch 0002 to the latest wip-fscrypt branch.
>
> - Added some documentation regarding snapshots naming restrictions.
>
> As before, in order to test this code the following PRs are required:
>
>    mds: add protection from clients without fscrypt support #45073
>    mds: use the whole string as the snapshot long name #45192
>    mds: support alternate names for snapshots #45224
>    mds: limit the snapshot names to 240 characters #45312
>
> Luís Henriques (3):
>    ceph: add support for encrypted snapshot names
>    ceph: add support for handling encrypted snapshot names
>    ceph: update documentation regarding snapshot naming limitations
>
>   Documentation/filesystems/ceph.rst |  10 ++
>   fs/ceph/crypto.c                   | 158 +++++++++++++++++++++++++----
>   fs/ceph/crypto.h                   |  11 +-
>   fs/ceph/inode.c                    |  31 +++++-
>   4 files changed, 182 insertions(+), 28 deletions(-)
>

