Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B27AD5EDF
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2019 11:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730898AbfJNJ3i (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Oct 2019 05:29:38 -0400
Received: from mail-io1-f53.google.com ([209.85.166.53]:37799 "EHLO
        mail-io1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730667AbfJNJ3h (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Oct 2019 05:29:37 -0400
Received: by mail-io1-f53.google.com with SMTP id b19so36517343iob.4
        for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2019 02:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KY0XdoywdB3LC54iMZ7NeHt/wUvKNA4bcTigux6w/hk=;
        b=nN6era/k6lNxHhjb21RQpPB/sUYoyKVY8YNhpgmmbGoRjanflk4S2QdPOl7NXiwa2u
         B7UlHe4fgbs/n0pqSPFhEWFpSojyGRRZXjbSDLYs3sWFhGfOLHfk1mdj9TK9M1ihn/wn
         Ruz/gi6DOAPwgpN72FY/8upzMK4NphwGRKOnk9kWgQL7C9y7S0Rqmf5tKUwT7dX6eyIL
         i4dzlMvdj8s7Iuosin5IRpHklYnHXbErgaRjvUeF2rylslBvrBJW6u7Iq9oX7PTRsJyf
         f3fBhadjlGZjkTwr7Wjq54juuVYOon60/nW0uMb/bwSFwezw3gHkcLYbKj95KXe/yrD6
         iBoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KY0XdoywdB3LC54iMZ7NeHt/wUvKNA4bcTigux6w/hk=;
        b=S29HfwkWGdc1eycaRPPoC2Z0iq6VKB/2TfGoUU9xXvNqROhDuk7EpkYCxmGHhBY51M
         LeKO0vAtdEiFK0J2K019NH0GO/1CYdvzVA0cSUDaeSY145SuUlxV9t2qsRDmt9Pjx0X3
         ult2H3c2PVuZXAXaVNpDBlNGMlD5lVscb5W5wyUAY4OZGpPxoagANGMroyELwT9Rro22
         ZqQrvZMwhSC16m98qMvcFfwoi+AG1zeQ6AOrqodP1+eAp7jRQY2F+JS6x75XSkT50hDH
         74XP0P4yChZzyC5zqERuqx53+LJWra6m/ETpZaSmT0Qb17iU33S/SnT+oiDLtUedz5x9
         qCkQ==
X-Gm-Message-State: APjAAAWPCIr3kub7wCpivzDOgrXkYYHcxiVM1FKHJLFgcDHgzj2nWUY9
        0dtzUOVLgyMGKBp1CkGv0lVK2QtxAXh5k2RoexeXxA==
X-Google-Smtp-Source: APXvYqwzKkGc4yzFQA/IUGGam9IyFlUKza4fXfZ83yKzJVvXwdQT4I+xdaejpWZWr4W1MwigJWY8t+1NHEzbspTf+2U=
X-Received: by 2002:a02:52c4:: with SMTP id d187mr37377428jab.127.1571045376641;
 Mon, 14 Oct 2019 02:29:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAMrPN_JjckOAnQC_=C+YJ1+QTMRbUkGSu24Pyuo1EC=rfXGuRQ@mail.gmail.com>
 <555f9bd9-8523-02ab-d7b0-97cd860c4d71@redhat.com> <CAMrPN_+U2d++xXGvY=SSBZZS_B447jzEEZZY9pPM6U1CfoDk5w@mail.gmail.com>
 <CAEYCsVLaLHBY4D4hr7qu5QKO54GgPgh5d6hC_VCPZ7s64OAZfg@mail.gmail.com>
In-Reply-To: <CAEYCsVLaLHBY4D4hr7qu5QKO54GgPgh5d6hC_VCPZ7s64OAZfg@mail.gmail.com>
From:   "Honggang(Joseph) Yang" <eagle.rtlinux@gmail.com>
Date:   Mon, 14 Oct 2019 17:29:25 +0800
Message-ID: <CAMrPN_Lb4fC7mky95bKPnEoRFG5OkXDB4ezd-mcrQtacMf+ehw@mail.gmail.com>
Subject: Re: local mode -- a new tier mode
To:     Xiaoxi Chen <superdebuger@gmail.com>
Cc:     Mark Nelson <mnelson@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>, dev@ceph.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 14 Oct 2019 at 10:31, Xiaoxi Chen <superdebuger@gmail.com> wrote:
>
> Several considerations on deployment:
>
> 1.  How a traditional OSD(filestore, or bluestore W/O local cache) behavi=
or if the OSD is selected as a PG member of the local-cache-pool?
> hopefully the osd can just work as-is like an OSD with CACHE-FULL.
>

Only the pools whose cache mode is local will be affected, all other
pools share the same osds will just act like before.

> 2.  Compared to other *global* caching mode, local-cache-mode cannot scal=
e cache tier/storage tier separately, which will be a big caveats in real p=
roduction environment,  especially for those case that the working set is c=
onsistent but the archival data amount is keeping  increasing.
>
> Overall it seems like a alternative for b-cache/flashcache/i-cas , more t=
est or analysis is needed to understand the benefit of this approach over t=
he existing b-cache solution.
>

Yes, this is a problem.

For now, tier local mode only support SSD:HDD =3D 1:1 mode.

If you want to extend cache's size under tier local mode, you can:
- disable tier local mode
- flush all fast objects to HDD
- replace SSD dev to a large one
- enable local mode again

or add more SSD:HDD pairs into the related crush domain.

> Honggang(Joseph) Yang <eagle.rtlinux@gmail.com> =E4=BA=8E2019=E5=B9=B410=
=E6=9C=8813=E6=97=A5=E5=91=A8=E6=97=A5 =E4=B8=8B=E5=8D=888:47=E5=86=99=E9=
=81=93=EF=BC=9A
>>
>> After the sysbench prepare operation is completed, about 48883MB of db
>> data is generated.
>> I set the fast partition to 30GB, so in the sysbench run stage,
>> eviction was taking place.
>>
>> Mark Nelson <mnelson@redhat.com> =E4=BA=8E2019=E5=B9=B410=E6=9C=8812=E6=
=97=A5=E5=91=A8=E5=85=AD =E4=B8=8A=E5=8D=8812:15=E5=86=99=E9=81=93=EF=BC=9A
>> >
>> > Hi Honggang,
>> >
>> >
>> > I personally I find this very exciting!  I was hoping that we might
>> > eventually try local caching in bluestore especially given trends for
>> > larger NVMe devices and pmem.  When you were running performance tests=
,
>> > did you run any tests where the data set size was significantly larger
>> > than the available "fast" local tier cache (ie so that eviction was
>> > taking place)?  In the past, that's been the area we've really needed =
to
>> > focus on getting right.
>> >
>> >
>> > Mark
>> >
>> >
>> > On 10/11/19 11:04 AM, Honggang(Joseph) Yang wrote:
>> > > Hi,
>> > >
>> > > We implemented a new cache tier mode - local mode. In this mode, an
>> > > osd is configured to manage two data devices, one is fast device, on=
e
>> > > is slow device. Hot objects are promoted from slow device to fast
>> > > device, and demoted from fast device to slow device when they become
>> > > cold.
>> > >
>> > > The introduction of tier local mode in detail is
>> > > https://tracker.ceph.com/issues/42286
>> > >
>> > > tier local mode: https://github.com/yanghonggang/ceph/commits/wip-ti=
er-new
>> > >
>> > > This work is based on ceph v12.2.5. I'm glad to port it to master
>> > > branch if needed.
>> > >
>> > > Any advice and suggestions will be greatly appreciated.
>> > >
>> > > thx,
>> > >
>> > > Yang Honggang
