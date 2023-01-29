Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB11F67FC3C
	for <lists+ceph-devel@lfdr.de>; Sun, 29 Jan 2023 02:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbjA2B7r (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 28 Jan 2023 20:59:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjA2B7q (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 28 Jan 2023 20:59:46 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9388D22A12
        for <ceph-devel@vger.kernel.org>; Sat, 28 Jan 2023 17:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674957537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lm/zleevAOHfhvldCPeoe9BMwYFKEqLFrBFPxs3/KEc=;
        b=B8gAt7xL7l3VYY+6qylCtk7j5SXbgq7avJ4JaJHTy/IcaZvss7M5LNvG69cNcDNLTHKa4o
        uldvoCQLAyW53r8ZsPbzXqoLCtGziGLjvpH0RoV5qM4+pBfC+OAWZ+H6DMgV4b4sR/NRtr
        q8pil2muC8HVQv9hVSqXEBnE0JFBjJI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-152-OCC8c0lBP-G-AOwkzG5cLQ-1; Sat, 28 Jan 2023 20:58:55 -0500
X-MC-Unique: OCC8c0lBP-G-AOwkzG5cLQ-1
Received: by mail-pj1-f72.google.com with SMTP id y6-20020a17090ad70600b0022c755b04fcso807622pju.1
        for <ceph-devel@vger.kernel.org>; Sat, 28 Jan 2023 17:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lm/zleevAOHfhvldCPeoe9BMwYFKEqLFrBFPxs3/KEc=;
        b=obSd9NHuoIfilV6ybwqeSmj8cJh+XyM4MTF1nUpyfjoipD6APhtIcyDSQwXIlbBbt2
         Kd7uH0u/gc3Y8Lsp6WOhRMD3jv++WIm18AxeJcUFxsIZuL1EnFaPdj1vcFtxwrAAdjjS
         +IDbiYRr3/+SB39jEircwV0HJzVoR3ukLhNh4TW7Sl2/kbCi7OLgHYPRvuwqJtRbya+Q
         G0jXSabuELCoFtRwMrc6FxpIN0U4K69FOScQkcEJesSI1Rl9XVkNWO+FcErKJxA/kflp
         bu2qJfNAWxEpPdNNZ4iJ0AFdmK9biNeboNCYTI+fprMXXRUUyKorarkPaRzAiTy+MKjb
         RTGQ==
X-Gm-Message-State: AO0yUKUXgluosRM3eL4vOTQAJJHOPN8v0TvHb4LFukSCHfi91gj1QyAt
        c7lIInOcUpGO9DyUzOkDhxATH8g8y+MY4BIxuROazB/UJKijmZSTG07BJhCE3eosFqLz/TujIW2
        uYFcrNkrIDEYz1aHBEHukgw==
X-Received: by 2002:a17:90b:33ca:b0:22c:8161:5143 with SMTP id lk10-20020a17090b33ca00b0022c81615143mr1820631pjb.31.1674957534919;
        Sat, 28 Jan 2023 17:58:54 -0800 (PST)
X-Google-Smtp-Source: AK7set+0eABGxp7P0r69pDt8iQjz6/XQJEhFNcULQp0eOZnRElg6OTXH7uyrlt9e64oz2AHPfsSkgQ==
X-Received: by 2002:a17:90b:33ca:b0:22c:8161:5143 with SMTP id lk10-20020a17090b33ca00b0022c81615143mr1820618pjb.31.1674957534635;
        Sat, 28 Jan 2023 17:58:54 -0800 (PST)
Received: from [10.72.13.156] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q95-20020a17090a1b6800b0022698aa22d9sm5357735pjq.31.2023.01.28.17.58.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Jan 2023 17:58:54 -0800 (PST)
Message-ID: <6c931f0e-45ca-725e-02ab-403e0031fa74@redhat.com>
Date:   Sun, 29 Jan 2023 09:58:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] ceph: drop the messages from MDS when unmouting
Content-Language: en-US
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        ceph-devel@vger.kernel.org, jlayton@kernel.org,
        mchangir@redhat.com, vshankar@redhat.com
References: <20221221093031.132792-1-xiubli@redhat.com>
 <Y8lvXRmHKGdORhs5@suse.de> <Y8pus+5ZciJa/apW@suse.de>
 <cfd149ba-69cb-6514-db03-5cbd113bf5dc@redhat.com> <Y85eRQlbwt4Z4xko@suse.de>
 <e11c7958-62c6-d960-77db-e4fae33543e0@redhat.com> <Y8/P0kg4VtC6UtD9@suse.de>
 <85021e1d-6668-47cf-e1b6-6cde8d0fe46d@redhat.com>
 <CAOi1vP8DtKgsuDjzu7otp2HB41nbtUAydfcpNzJQUCk=V_xaUw@mail.gmail.com>
 <05ce0c89-6b40-20eb-a2f3-af1fdd5bc516@redhat.com>
 <CAOi1vP8jSHtseVveGegXOCbFyjrbamJ=WUunA3L0OrxBEnTaEQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <CAOi1vP8jSHtseVveGegXOCbFyjrbamJ=WUunA3L0OrxBEnTaEQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 29/01/2023 01:41, Ilya Dryomov wrote:
> On Sat, Jan 28, 2023 at 4:12 AM Xiubo Li <xiubli@redhat.com> wrote:
[...]
>>> Hi Xiubo,
>>>
>>> I haven't looked into the actual problem that you trying to fix here
>>> but this patch seems wrong and very unlikely to fly.  The messenger
>>> invokes the OSD request callback outside of osd->lock and osdc->lock
>>> critical sections on purpose to avoid deadlocks.  This goes way back
>>> and also consistent with how Objecter behaves in userspace.
>> Hi Ilya
>>
>> This is just a draft patch here.
>>
>> I didn't test other cases yet and only tested the issue here in cephfs
>> and it succeeded.
>>
>> The root cause is the sequence issue to make the sync_filesystem()
>> failing to wait the last osd request, which is the last
>> req->r_callback() isn't finished yet the waiter is woke up. And more
>> detail please see my comment in
>> https://tracker.ceph.com/issues/58126?issue_count=405&issue_position=3&next_issue_id=58082&prev_issue_id=58564#note-7.
> Hi Xiubo,
>
> This seems to boil down to an expectation mismatch.  The diagram in the
> tracker comment seems to point the finger at ceph_osdc_sync() because
> it appears to return while req->r_callback is still running.  This can
> indeed be the case but note that ceph_osdc_sync() has never waited for
> any higher-level callback -- req->r_callback could schedule some
> delayed work which the OSD client would know nothing about, after all.
> ceph_osdc_sync() just waits for a safe/commit reply from an OSD (and
> nowadays all replies are safe -- unsafe/ack replies aren't really
> a thing anymore).

Hi Ilya,

Yeah, for cephfs the req->r_callback() will release all the resources 
directly the unmounting thread is waiting for and it's enough.

For the higher-level callback you mentioned above in cephfs it should be 
at the same time the last req->r_callback() will flush the dirty 
cap/snap to MDSs, which may send some ack replies back later and will 
ihold() the inodes, and this will cause another crash in 
https://tracker.ceph.com/issues/58126?issue_count=405&issue_position=3&next_issue_id=58082&prev_issue_id=58564#note-5. 
This is another story, if the unmounting finishes just before the acks 
come they will be dropped directly, if the acks come faster while the 
unmouting is not finished yet it will update the inodes and then the 
inodes will be evicted. So the acks makes no sense any more and this is 
why I need this patch to drop the ack replies.

Thanks

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

