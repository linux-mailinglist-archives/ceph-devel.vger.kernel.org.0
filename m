Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5B86821B2
	for <lists+ceph-devel@lfdr.de>; Tue, 31 Jan 2023 02:59:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbjAaB7J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 30 Jan 2023 20:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbjAaB7H (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 30 Jan 2023 20:59:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A5E2686B
        for <ceph-devel@vger.kernel.org>; Mon, 30 Jan 2023 17:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675130304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YGV6ctQH71hSREAm9gWfHUYIItUK9RXubMmg0nlGnEI=;
        b=bJjWmPr1MroV9+WwuAGbzAb6SkjTazyVcAgCBBicBfE/55ChQkeuiJ88j3AlMVb9EcAGo6
        g9HFn7s+Zv1cwmrP3yVW7ub8zSl7RmbFxLhbZhC/IJhSsdugy+MqUIsiYzSD71sE2sQF05
        RCS9uJ8zOI/UebnPad6zPJaUe20NapY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-121-rgE59Y7uP96YqVKmS8n5sA-1; Mon, 30 Jan 2023 20:58:23 -0500
X-MC-Unique: rgE59Y7uP96YqVKmS8n5sA-1
Received: by mail-pf1-f200.google.com with SMTP id x9-20020aa79409000000b00593a1f7c3d8so3057229pfo.14
        for <ceph-devel@vger.kernel.org>; Mon, 30 Jan 2023 17:58:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YGV6ctQH71hSREAm9gWfHUYIItUK9RXubMmg0nlGnEI=;
        b=lpWlYmIMVRWcZvaIVlC7CqHsdEBC2YFMIjO83gcKFya7aLXbRc80hEwCfz3V8SXN5C
         HU8rj7QxwHs+AyhAcWi8Chg1KySHJhsmrshpA4UDmXv8VnhFDVpk/SXCBXa/lnEvZiIY
         erolcM4IGX5wugm3pCx5GvmGmLdYrWKYxF89dm3minSoYwQR8CWEZxA3C9X7yfQsAsVH
         zTIe+/Imd7LVrAz/A5BKxzWEL3l7F+aHOwpHt9WVstxYR4SwjCATbfhISsFQb1Pm44+N
         B7SfeJWwRrF/WXqYLGHhWXgFoCXi97G4jWDALTi+uz6sCr1RbW+qZvb5IySqG0hNZ9/P
         /vVg==
X-Gm-Message-State: AO0yUKWC/W1UgvnV3KglAA02m2II0+flT81Lw4dsxbFAgt+VYACelrVG
        hCRIjwKCbMgwiq3HuvLFakYwEcfM6VV284V0B8GV6S8PSDESygUyGhm2isruH0SakVTfk/zatbm
        CwFXkVFp8mqWAbxpU/sdYiA==
X-Received: by 2002:a05:6a20:7d90:b0:bc:51a4:d14c with SMTP id v16-20020a056a207d9000b000bc51a4d14cmr16791567pzj.16.1675130302615;
        Mon, 30 Jan 2023 17:58:22 -0800 (PST)
X-Google-Smtp-Source: AK7set8/xqapQqIkett8hPtVCR/aVHbs2nUigvEDW3/xi3H/f8sVsqbSpVCL2F3a8xYC2soGF2dTTQ==
X-Received: by 2002:a05:6a20:7d90:b0:bc:51a4:d14c with SMTP id v16-20020a056a207d9000b000bc51a4d14cmr16791551pzj.16.1675130302417;
        Mon, 30 Jan 2023 17:58:22 -0800 (PST)
Received: from [10.72.13.217] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b26-20020a63715a000000b00478e7f87f3bsm7432673pgn.67.2023.01.30.17.58.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 17:58:21 -0800 (PST)
Message-ID: <e7c5cad0-5727-8cb3-4126-12aac8f4bdd3@redhat.com>
Date:   Tue, 31 Jan 2023 09:58:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 0/2] ceph: drop the messages from MDS when unmouting
Content-Language: en-US
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, mchangir@redhat.com, vshankar@redhat.com,
        lhenriques@suse.de
References: <20230130084147.122440-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20230130084147.122440-1-xiubli@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

With this I have passed all the xfstests-dev test cases with the 
test_dummy_encryption option enabled, more detail please see:

https://tracker.ceph.com/issues/58126?issue_count=91&issue_position=7&next_issue_id=58489&prev_issue_id=58602#note-9

Thanks

- Xiubo

On 30/01/2023 16:41, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> V3:
> - Fix the sequence of removing the requests from osdc and calling the
> req->r_callback().
> - Add a block counter to block the unmounting if there is any inflight
> cap/snap/lease reply message is running.
>
> V2:
> - Fix it in ceph layer.
>
> Xiubo Li (2):
>    libceph: defer removing the req from osdc just after req->r_callback
>    ceph: drop the messages from MDS when unmounting
>
>   fs/ceph/caps.c        |  5 +++++
>   fs/ceph/mds_client.c  | 12 +++++++++-
>   fs/ceph/mds_client.h  | 11 ++++++++-
>   fs/ceph/quota.c       |  4 ++++
>   fs/ceph/snap.c        |  6 +++++
>   fs/ceph/super.c       | 52 +++++++++++++++++++++++++++++++++++++++++++
>   fs/ceph/super.h       |  2 ++
>   net/ceph/osd_client.c | 43 ++++++++++++++++++++++++++++-------
>   8 files changed, 125 insertions(+), 10 deletions(-)
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

