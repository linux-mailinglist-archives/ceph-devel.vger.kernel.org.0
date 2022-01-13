Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C40F848D067
	for <lists+ceph-devel@lfdr.de>; Thu, 13 Jan 2022 03:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiAMCTD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 12 Jan 2022 21:19:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21392 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231634AbiAMCS5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 12 Jan 2022 21:18:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642040335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uIhJzoKJpntmLV9bnodQNulswiXzDKfPmixlWQFR4VU=;
        b=HA4oqbGKy0coXglo3oMGzOAJrrOr0vs2rQlP505yoX1fTqFxn6m0ZXG13QNt9pfIe9gVPw
        Lh77ldBs0AAsvQUWn41Mq3ti6iQIOQhJccEqLDextzKr31ODfZ9tDczPCd2xZ4vJMpXi+G
        0BZQIbxf9kYseQ/K22pMYVGUwvPhxbQ=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-417-MdigOqK2NIOefr-Q1rncZg-1; Wed, 12 Jan 2022 21:18:54 -0500
X-MC-Unique: MdigOqK2NIOefr-Q1rncZg-1
Received: by mail-pj1-f69.google.com with SMTP id o7-20020a17090a3d4700b001b4243e9ea2so627678pjf.6
        for <ceph-devel@vger.kernel.org>; Wed, 12 Jan 2022 18:18:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uIhJzoKJpntmLV9bnodQNulswiXzDKfPmixlWQFR4VU=;
        b=4TZP+WgFZyKY5nWjco0hCIoU+Z26uBrdcpEu1BHoHYjDP0QZRFKvcY0gGZ6DRgy2+3
         9eGFcS0sm3zwi6f7qGB5xCUBoYXsB8BZasSPSP8NGix3l/T1t7UvCHzK5Zjqxfije5oD
         xiRcekxknRCq7jd1tLvcw8c4a9IJD9IlcstRbSByOJMsw9B6+4f+lBYH7aLrMt5Jymv7
         6rH3dqQ6Kfc2sc9di5MABbHcnq22ntKM88A5FMdOE54e2+s2NvOFawhTbfEVApbiAP1q
         e5iawUPGFRoDuJTC8nSkjT55kkmevWofiMapU50li/n00KnIpcuDBljPgYRHrjTXUALY
         z7Kg==
X-Gm-Message-State: AOAM533tZqio+3RVi9bdbT2MajeAj+IyoMSlR19tNOdGArRZLsnfcc4U
        Gag4pqB3BiIbyheZThlPW0lK18BssOh4KrXVTMpb7hM/GO+KiWW87xOFkNUU8TrzpBGjKDAqSru
        ujs48C7itwiLsLNJs3NLlPA==
X-Received: by 2002:a17:903:244e:b0:14a:537b:db0b with SMTP id l14-20020a170903244e00b0014a537bdb0bmr2310730pls.28.1642040332532;
        Wed, 12 Jan 2022 18:18:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz40DdDOVd/F1VZmXI8DURF4UILOlapg/oJ0FheAHsJjrY3Xq7AA0wcEQs5216fSYXtD9ERsg==
X-Received: by 2002:a17:903:244e:b0:14a:537b:db0b with SMTP id l14-20020a170903244e00b0014a537bdb0bmr2310717pls.28.1642040332258;
        Wed, 12 Jan 2022 18:18:52 -0800 (PST)
Received: from [10.72.12.99] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d1sm758776pge.62.2022.01.12.18.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Jan 2022 18:18:51 -0800 (PST)
Subject: Re: dmesg: mdsc_handle_reply got x on session mds1 not mds0
To:     Gregory Farnum <gfarnum@redhat.com>,
        Venky Shankar <vshankar@redhat.com>
Cc:     =?UTF-8?B?6IOh546u5paH?= <sehuww@mail.scut.edu.cn>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>
References: <787e011c.337c.17e400efdc7.Coremail.sehuww@mail.scut.edu.cn>
 <CACPzV1n3bRtd_87Yuh2ukHnNWZBFrXPnQ_EMtDc7oipjOEe6xA@mail.gmail.com>
 <CAJ4mKGY_Vr6OEe+aO9sXS6tAk9mVgtZga=eFbtsG3QY58KPHqQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <0a88e924-97d4-c62a-e8de-cfb3e10e9009@redhat.com>
Date:   Thu, 13 Jan 2022 10:18:45 +0800
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

