Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10F5178A3EB
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Aug 2023 03:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjH1Bbo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 27 Aug 2023 21:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjH1Bbl (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 27 Aug 2023 21:31:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B35510E
        for <ceph-devel@vger.kernel.org>; Sun, 27 Aug 2023 18:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693186252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iXnLgOiqk5iWjqr83zA5rJW1ivGKK2OzxDGCdpxM3FU=;
        b=g7G9biZ04owZ/Odb92CHHougKM3YEUzzoZ//C/Mzud7hZheVxMqPbBwlOJgFc5Qa6P7bcx
        6s18WToRJO0yvKZu5KhYrgyRUpKLvSEj8gvVkQ1QB3mrSTqxld4cis9oBdZXTL0cgnQ0+n
        +OZRwzBwFzyMuATA27qjQ+z0OYmMp9c=
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com
 [209.85.160.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-DhG8gaBGPU-KAFO3Y8XXUA-1; Sun, 27 Aug 2023 21:30:50 -0400
X-MC-Unique: DhG8gaBGPU-KAFO3Y8XXUA-1
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-1c8c1f34aadso3379991fac.3
        for <ceph-devel@vger.kernel.org>; Sun, 27 Aug 2023 18:30:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693186249; x=1693791049;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iXnLgOiqk5iWjqr83zA5rJW1ivGKK2OzxDGCdpxM3FU=;
        b=BaZvMX5om8HDWMhfWx5N881txeHJ6xfQ7BUKwxwZCOCt9ZYmVsrPnxy7c+JYL+VTxR
         aCkO3lb0FWDjX/zMF0AKBcrHdGBq2lUbSxQxgHyea8+J8KOJ6/1jFGdN6Pj6TPmIqoVG
         2D3Skn5bZt2HAPBygF7UoxnMQB+FyiofTwpAlCJ6rjPZ8c9twF/d2OLcUuuSpfhdDqwG
         22DyhHLIqMCnzKQqMks3lJSWF2d81flFKj5GoaO0C9DWam7NoWR4DJGUMKBxo8EG2Mms
         IG8K2Be1kmOLOnS8+QlycqWUV8uXTSvLhGbumKYG82qH95OZNVn7i8zz9sg0CmVvxn+z
         WCSg==
X-Gm-Message-State: AOJu0Yy65SH74C1YTBpaiIRpWTNZRZ8o7N0aVqsHqFmZQgFZtIUcCRtx
        umpozm2RwWPw+fpOyywFSyIADPHB/vt8c5K/iAuP+scOO3MDlrbN06XN2Bza4yyzJjKvcYp0Kp0
        0u6PJYXfbpxw2GK5Pa1m9hQ==
X-Received: by 2002:a05:6871:54e:b0:1c8:ca70:dd0c with SMTP id t14-20020a056871054e00b001c8ca70dd0cmr10849404oal.19.1693186249653;
        Sun, 27 Aug 2023 18:30:49 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEGC0BwJIXFO6tXCBMB05auta8S9eX5z0u4Q7lCQD0uk7uqjNg1uIqJw+FXGvj62JU0uFvOTw==
X-Received: by 2002:a05:6871:54e:b0:1c8:ca70:dd0c with SMTP id t14-20020a056871054e00b001c8ca70dd0cmr10849397oal.19.1693186249402;
        Sun, 27 Aug 2023 18:30:49 -0700 (PDT)
Received: from [10.72.112.71] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id gf15-20020a17090ac7cf00b00268032f6a64sm7532175pjb.25.2023.08.27.18.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Aug 2023 18:30:48 -0700 (PDT)
Message-ID: <9d4a2348-608c-249e-1aab-25332a07e0a4@redhat.com>
Date:   Mon, 28 Aug 2023 09:30:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [RFC PATCH 00/18] ceph, rbd: Collapse all the I/O types down to
 something iov_iter-based
Content-Language: en-US
To:     David Howells <dhowells@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230804131327.2574082-1-dhowells@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230804131327.2574082-1-dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 8/4/23 21:13, David Howells wrote:
> Hi Ilya, Xiubo,
>
> [!] NOTE: This is a preview of a work in progress and doesn't yet fully
>      compile, let alone actually work!
>
> Here are some patches that (mostly) collapse the different I/O types
> (PAGES, PAGELIST, BVECS, BIO) down to a single one.  I added a new type,
> ceph_databuf, to make this easier.  The page list is attached to that as a
> bio_vec[] with an iov_iter, but could also be some other type supported by
> the iov_iter.  The iov_iter defines the data or buffer to be used.  I have
> an additional iov_iter type implemented that allows use of a straight
> folio[] or page[] instead of a bio_vec[] that I can deploy if that proves
> more useful.
>
> The conversion isn't quite complete:
>
>   (1) rbd is done; BVECS and BIO types are replaced with ceph_databuf.
>
>   (2) ceph_osd_linger_request::preply_pages needs switching over to a
>       ceph_databuf, but I haven't yet managed to work out how the pages that
>       handle_watch_notify() sticks in there come about.
>
>   (3) I haven't altered data transmission in net/ceph/messenger*.c yet.  The
>       aim is to reduce it to a single sendmsg() call for each ceph_msg_data
>       struct, using the iov_iter therein.
>
>   (4) The data reception routines in net/ceph/messenger*.c also need
>       modifying to pass each ceph_msg_data::iter to recvmsg() in turn.
>
>   (5) It might be possible to merge struct ceph_databuf into struct
>       ceph_msg_data and eliminate the former.
>
>   (6) fs/ceph/ still needs some work to clean up the use of page arrays.
>
>   (7) I would like to change front and middle buffers with a ceph_databuf,
>       vmapping them when we need to access them.
>
> I added a kmap_ceph_databuf_page() macro and used that to get a page and
> use kmap_local_page() on it to hide the bvec[] inside to make it easier to
> replace.
>
> Anyway, if anyone has any thoughts...
>
>
> I've pushed the patches here also:
>
> 	https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=iov-extract
>
> David
>
> David Howells (18):
>    iov_iter: Add function to see if buffer is all zeros
>    ceph: Rename alignment to offset
>    ceph: Add a new data container type, ceph_databuf
>    ceph: Convert ceph_mds_request::r_pagelist to a databuf
>    rbd: Use ceph_databuf for rbd_obj_read_sync()
>    ceph: Change ceph_osdc_call()'s reply to a ceph_databuf
>    ceph: Unexport osd_req_op_cls_request_data_pages()
>    ceph: Remove osd_req_op_cls_response_data_pages()

David,

I think the titles should be prefixed with "libceph: XXX" for the 
patches in net/ceph/ ?

Thanks

- Xiubo


>    ceph: Convert notify_id_pages to a ceph_databuf
>    rbd: Switch from using bvec_iter to iov_iter
>    ceph: Remove bvec and bio data container types
>    ceph: Convert some page arrays to ceph_databuf
>    ceph: Convert users of ceph_pagelist to ceph_databuf
>    ceph: Remove ceph_pagelist
>    ceph: Convert ceph_osdc_notify() reply to ceph_databuf
>    ceph: Remove CEPH_OS_DATA_TYPE_PAGES and its attendant helpers
>    ceph: Remove CEPH_MSG_DATA_PAGES and its helpers
>    ceph: Don't use data_pages
>
>   drivers/block/rbd.c             | 645 ++++++++++----------------------
>   fs/ceph/acl.c                   |  39 +-
>   fs/ceph/addr.c                  |  18 +-
>   fs/ceph/file.c                  | 157 ++++----
>   fs/ceph/inode.c                 |  85 ++---
>   fs/ceph/locks.c                 |  23 +-
>   fs/ceph/mds_client.c            | 134 ++++---
>   fs/ceph/mds_client.h            |   2 +-
>   fs/ceph/super.h                 |   8 +-
>   fs/ceph/xattr.c                 |  68 ++--
>   include/linux/ceph/databuf.h    |  65 ++++
>   include/linux/ceph/messenger.h  | 141 +------
>   include/linux/ceph/osd_client.h |  97 ++---
>   include/linux/ceph/pagelist.h   |  72 ----
>   include/linux/uio.h             |   1 +
>   lib/iov_iter.c                  |  22 ++
>   net/ceph/Makefile               |   5 +-
>   net/ceph/cls_lock_client.c      |  40 +-
>   net/ceph/databuf.c              | 149 ++++++++
>   net/ceph/messenger.c            | 376 +------------------
>   net/ceph/osd_client.c           | 430 +++++++--------------
>   net/ceph/pagelist.c             | 171 ---------
>   22 files changed, 876 insertions(+), 1872 deletions(-)
>   create mode 100644 include/linux/ceph/databuf.h
>   delete mode 100644 include/linux/ceph/pagelist.h
>   create mode 100644 net/ceph/databuf.c
>   delete mode 100644 net/ceph/pagelist.c
>

