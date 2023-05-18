Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD05707768
	for <lists+ceph-devel@lfdr.de>; Thu, 18 May 2023 03:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjERBZP (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 17 May 2023 21:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjERBZO (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 17 May 2023 21:25:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FA34488
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 18:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684373066;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N30WZ/QjDm649/MsmsRhEAJVLgFMmg+chQY+VOfJ3A0=;
        b=D4aK0YaKF/nv7R+c4ndreq0wWmxnH3xNoxQaUZL2Fi2JSNblrJUkO/ZdMbQ7IrLGgud/EB
        j+zKLTo8PGRdwPJLcPQZLqW6UcOWJctMfl6oVeKK038fkM3czMUc2hLyF7psZ8HzuxgPd/
        E/bz+QOIdG9QKSnirgspPX8VD1xFwSw=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-SOXpAVwSOkCYB4nvI3rASA-1; Wed, 17 May 2023 21:24:25 -0400
X-MC-Unique: SOXpAVwSOkCYB4nvI3rASA-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1ae5a30a9c4so3755435ad.1
        for <ceph-devel@vger.kernel.org>; Wed, 17 May 2023 18:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684373064; x=1686965064;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N30WZ/QjDm649/MsmsRhEAJVLgFMmg+chQY+VOfJ3A0=;
        b=ST7aEOt2+ORLKkujOQa4OGPcX8ULB2qIke6mhd674TkdPyzs++2tWcM7Sk1E11Kaon
         X8xgFcywBz3lQMulDQk5UrBwYc8GSdTIe9SHy5kpAJVizHXf0mEWXWCsT8kNJa03YGYp
         wGHB6QegKJSUJ6nT39jpUz7som7zYO3fzZjQ4Get7z4ulB20F4vTP6IW5apTKeZfYkkm
         f1pO8xhw4f4keIUrzj7tC8pMCBzxaS83n2lAFCuQiJL99CWBx1i3sHQDiiXMar4GTNY6
         CyDikcx5zDQMpfgBvYX6dBeHH0BfNGyIw/Eye4F6pEb0MIO6b79a17W/q/O3orqFS1fs
         B0Nw==
X-Gm-Message-State: AC+VfDyiTJ8RAVRw/Mm1XhiUDfYesPUZ9ZGK1LP4PS/zBGcDdUv0PCO4
        ppZOiwC9mdVLOZpuFBB92DF6yTLWzAk8o/da8rj6jPRwxGyfhp+67cG+8Xn+tK1Y8MOij4hvtCk
        vXkSIQ+sLDWFoyw5vExQnXQ==
X-Received: by 2002:a17:902:ec82:b0:1ad:b5ed:e951 with SMTP id x2-20020a170902ec8200b001adb5ede951mr489472plg.13.1684373064408;
        Wed, 17 May 2023 18:24:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6XNNFkE+xmskfWabpsCD3gXDM+Lzwdi4SRadHHRsykTK3wrEbOx3zYKECKnw7Vz1msPWq/cQ==
X-Received: by 2002:a17:902:ec82:b0:1ad:b5ed:e951 with SMTP id x2-20020a170902ec8200b001adb5ede951mr489460plg.13.1684373064025;
        Wed, 17 May 2023 18:24:24 -0700 (PDT)
Received: from [10.72.12.110] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v10-20020a170902b7ca00b001a9581d3ef5sm33327plz.97.2023.05.17.18.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 18:24:23 -0700 (PDT)
Message-ID: <d08f0c14-a4ee-5416-cd59-2032d8ad4020@redhat.com>
Date:   Thu, 18 May 2023 09:24:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] ceph: force updating the msg pointer in non-split case
Content-Language: en-US
To:     Frank Schilder <frans@dtu.dk>, Gregory Farnum <gfarnum@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "jlayton@kernel.org" <jlayton@kernel.org>,
        "vshankar@redhat.com" <vshankar@redhat.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20230517052404.99904-1-xiubli@redhat.com>
 <CAOi1vP8e6NrrrV5TLYS-DpkjQN6LhfqkptR5_ue94HcHJV_2ag@mail.gmail.com>
 <b121586f-d628-a8e3-5802-298c1431f0e5@redhat.com>
 <CAOi1vP-vA0WAw6Jb69QDt=43fw8rgS7KvLrvKF5bEqgOS_TzUQ@mail.gmail.com>
 <CAJ4mKGbp3Csdy56hcnHLam6asCv9tMSANL_YzD6pM+NV3eQicA@mail.gmail.com>
 <CAOi1vP90QTPTtTmjRrskX4WEJKcPs52phS0C383eZxHmG4q5zQ@mail.gmail.com>
 <CAJ4mKGZUvrVHsEX-==kD9x_ArSL5FD_k0PDmYT4e6mo_80Ah_g@mail.gmail.com>
 <CAJ4mKGZ8YRyWYry5F8yAGDhpv3X_LkQHj+f9ONXKsrbWSjDVsQ@mail.gmail.com>
 <DB9P192MB1850391D744321AC8948F013D67E9@DB9P192MB1850.EURP192.PROD.OUTLOOK.COM>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <DB9P192MB1850391D744321AC8948F013D67E9@DB9P192MB1850.EURP192.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Thanks Frank for your feedback.

On 5/17/23 23:39, Frank Schilder wrote:
> Hi all,
>
> joining in here as the one who is hit pretty badly and also not being able to upgrade ceph any time soon to a version receiving patches.
>
> For these two reasons alone I strongly favour fixing both sides.
>
> Extra reading, feel free to skip.
>
> Additional reasons for fixing both sides are (1) to have more error tolerant code - if one side breaks/regresses the other side still knows what to do and can report back while moving on without a fatal crash and (2) to help users of old clusters who are affected without noticing yet. Every now and then one should afford to be nice.
>
> I personally think that (1) is generally good practice, explicitly handling seemingly unexpected cases increases overall robustness (its a bit like raiding up code to catch code rot) and will highlight otherwise unnoticed issues early in testing. It is not the first time our installation was hit by an unnecessarily missing catch-all clause that triggered an assert or follow-up crash for no real reason.
>
> The main reason we actually discovered this is that under certain rare circumstances it makes a server with a kclient mount freeze. There is some kind of follow-up condition that is triggered only under heavy load and almost certainly only at a time when a snapshot is taken. Hence, it is very well possible that many if not all users have these invalid snaptrace message on their system, but nothing else happens so they don't report anything.
>
> The hallmark in our case is a hanging client caps recall that eventually leads to a spontaneous restart of the affected MDS and then we end up with either a frozen server or a stale file handle at the ceph mount point. Others might not encounter these conditions simultaneously on their system as often as we do.
>
> Apart from that, its not even sure that this is the core issue causing all the trouble on our system. Having the kclient fixed would allow us to verify that we don't have yet another problem that should be looked at before considering a ceph upgrade - extra reason no. 3.
>
> I hope this was a useful point of view from someone suffering from the condition.
>
> Best regards and thanks for your efforts addressing this!
> =================
> Frank Schilder
> AIT Risø Campus
> Bygning 109, rum S14
>
>

