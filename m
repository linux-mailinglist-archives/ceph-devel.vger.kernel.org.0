Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E9948D066
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 03:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiAMCSp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 21:18:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56426 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231593AbiAMCSn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 21:18:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642040322;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uIhJzoKJpntmLV9bnodQNulswiXzDKfPmixlWQFR4VU=;
        b=iNJs898ajoqOMyekTp77hHtmLVDAaRPn5OifMrjOhdI/r0VKRqrZSoiwykXVHMsw9pIisM
        b0XML6m1xwfxnSRDQAccxLp3+c2LjYKweDH/eSzCeqA/767cCz3DZN9TgWDhQssa+PmrEK
        C+O31cBd7C/o8y3GIKRmJEyEUzfSSKI=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-272-m0GlqeGFM-KnPAh6Jzsv-A-1; Wed, 12 Jan 2022 21:18:41 -0500
X-MC-Unique: m0GlqeGFM-KnPAh6Jzsv-A-1
Received: by mail-pl1-f198.google.com with SMTP id w4-20020a170902d70400b0014a0068b558so4501648ply.13
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jan 2022 18:18:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uIhJzoKJpntmLV9bnodQNulswiXzDKfPmixlWQFR4VU=;
        b=lXt3SBBCghOPGR4lwMRdDnzbh4F1l1BT7xJ8zfSDvEFGvvtlbeIf+ipH59/nOhed7p
         jtkuycMwj1AyRJLFpDoP5uQKs9CKp30GZaM/1trEA1nt7v26zhJirPbAO2GSobpjxrFM
         7jiUOPcEext28nsjL3/shXgxzU7Ohuy3tUTQISJ348EDCPdD5AOcnK0hWWCw4wS5cQSL
         iAfsJxyNopg3GypmIjyV7+XBXPB8SRlJxtYh0la0lAeIoGmVKPGOOLA0zdJKg7Gspcud
         HBDYLMYs95ZUo7oohFi+YL4YMCjtqBBOq55v2xMEMzxnAIMnGEOAr0YB7RIewtdcbWV3
         Bb0w==
X-Gm-Message-State: AOAM532k2SMR4pFzC9r43w/1Jldjgezf9jhaFljkS7vynnCD17xidkAx
        vIfaaeeKkDNVejs5DFC2m/j/mMa0MDWwiTZl7qL9IkpKx4UEe89SamXD7o97x9JHDaqHCuS0mt8
        8bHP5IiSyt26tD55URgyuiA==
X-Received: by 2002:a17:90a:c296:: with SMTP id f22mr2774987pjt.212.1642040320392;
        Wed, 12 Jan 2022 18:18:40 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz5VABVGttxbEWpG/GSq9ctbgeAN+1Eh0IsbLkelfPgDkcoaRf4bBbW/FZ2hnl6h80Z6zi/VA==
X-Received: by 2002:a17:90a:c296:: with SMTP id f22mr2774975pjt.212.1642040320095;
        Wed, 12 Jan 2022 18:18:40 -0800 (PST)
Received: from [10.72.12.99] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u64sm809833pfb.208.2022.01.12.18.18.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 18:18:39 -0800 (PST)
Subject: Re: dmesg: mdsc_handle_reply got x on session mds1 not mds0
To:     Gregory Farnum <gfarnum@redhat.com>,
        Venky Shankar <vshankar@redhat.com>
Cc:     =?UTF-8?B?6IOh546u5paH?= <sehuww@mail.scut.edu.cn>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>
References: <787e011c.337c.17e400efdc7.Coremail.sehuww@mail.scut.edu.cn>
 <CACPzV1n3bRtd_87Yuh2ukHnNWZBFrXPnQ_EMtDc7oipjOEe6xA@mail.gmail.com>
 <CAJ4mKGY_Vr6OEe+aO9sXS6tAk9mVgtZga=eFbtsG3QY58KPHqQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <02b6123e-b2f1-2419-1025-1eca89ca05ab@redhat.com>
Date:   Thu, 13 Jan 2022 10:18:34 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <CAJ4mKGY_Vr6OEe+aO9sXS6tAk9mVgtZga=eFbtsG3QY58KPHqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 1/13/22 1:19 AM, Gregory Farnum wrote:
> On Tue, Jan 11, 2022 at 11:55 PM Venky Shankar <vshankar@redhat.com> wrote:
>> +Greg
>>
>> On Mon, Jan 10, 2022 at 12:08 AM 胡玮文 <sehuww@mail.scut.edu.cn> wrote:
>>> Hi ceph developers,
>>>
>>> Today we got one of our OSD hosts hang on OOM. Some OSDs were flapping and eventually went down and out. The recovery caused one OSD to go full, which is used in both cephfs metadata and data pools.
>>>
>>> The strange thing is:
>>> * Many of our users report unexpected “Permission denied” error when creating new files
>> That's weird. I would expect the operation to block in the worst case.
> I think some configurations or code paths end up returning odd errors
> instead of ENOSPC or EQUOTA, which is probably what the cluster was
> returning.
>
>>> * dmesg has some strange error (see examples below). During that time, no special logs on both active MDSes.
>>> * The above two strange things happens BEFORE the OSD got full.
>>>
>>> Jan 09 01:27:13 gpu027 kernel: libceph: osd9 up
>>> Jan 09 01:27:13 gpu027 kernel: libceph: osd10 up
>>> Jan 09 01:28:55 gpu027 kernel: libceph: osd9 down
>>> Jan 09 01:28:55 gpu027 kernel: libceph: osd10 down
>>> Jan 09 01:32:35 gpu027 kernel: libceph: osd6 weight 0x0 (out)
>>> Jan 09 01:32:35 gpu027 kernel: libceph: osd16 weight 0x0 (out)
>>> Jan 09 01:34:18 gpu027 kernel: libceph: osd1 weight 0x0 (out)
>>> Jan 09 01:39:20 gpu027 kernel: libceph: osd9 weight 0x0 (out)
>>> Jan 09 01:39:20 gpu027 kernel: libceph: osd10 weight 0x0 (out)
> All of these are just reports about changes in the OSDMap. It looks
> like something pretty bad happened with your cluster (an OSD filling
> up isn't good, but I didn't think on its own it would cause them to
> get marked down+out), but this isn't a direct impact on the kernel
> client or filesystem...
>
>>> Jan 09 01:53:07 gpu027 kernel: ceph: mdsc_handle_reply got 30408991 on session mds1 not mds0
>>> Jan 09 01:53:14 gpu027 kernel: ceph: mdsc_handle_reply got 30409829 on session mds1 not mds0
>>> Jan 09 01:53:15 gpu027 kernel: ceph: mdsc_handle_reply got 30409925 on session mds1 not mds0
>>> Jan 09 01:53:28 gpu027 kernel: ceph: mdsc_handle_reply got 30411416 on session mds1 not mds0
>>> Jan 09 02:05:07 gpu027 kernel: ceph: mdsc_handle_reply got 30417742 on session mds0 not mds1
>>> Jan 09 02:48:52 gpu027 kernel: ceph: mdsc_handle_reply got 30449177 on session mds1 not mds0
>>> Jan 09 02:49:17 gpu027 kernel: ceph: mdsc_handle_reply got 30452750 on session mds1 not mds0
>>>
>>> After reading the code, the replies are unexpected and just dropped. Any ideas about how this could happen? And is there anything I need to worry about? (The cluster is now recovered and looks good)
>> The MDS should ask the client to "forward" the operation to another
>> MDS if it is not the auth for an inode.
> Yeah. Been a while since I was in this code but I think this will
> generally happen if the MDS cluster is migrating metadata and the
> client for some reason hasn't kept up on the changes — the
> newly-responsible MDS might have gotten the request forwarded
> directly, and replied to the client, but the client doesn't expect it
> to be responsible for that op.
> *IIRC* it all gets cleaned up when the client resubmits the operation
> so this isn't an issue.
> -Greg

Actually it's buggy in MDS, and there has one PR is fixing this.

https://github.com/ceph/ceph/pull/44229

The 'try_get_auth_inode()' is possibly have already send the forward 
request to clients and the clients has changed the request->sesssion, 
but in 'dispatch_client_request()' it will respond it with '-EINVAL'.

The above errors should from the second respond.

Regards

-- Xiubo

>> It would be interesting to see what "mds1" was doing around the
>> "01:53:07" timestamp. Could you gather that from the mds log?
>>
>>> The clients are Ubuntu 20.04 with kernel 5.11.0-43-generic. Ceph version is 16.2.7. No active MDS restarts during that time. Standby-replay MDSes did restart, which should be fixed by my PR https://github.com/ceph/ceph/pull/44501 . But I don’t know if it is related to the issue here.
>>>
>>> Regards,
>>> Weiwen Hu
>>
>>
>> --
>> Cheers,
>> Venky
>>

