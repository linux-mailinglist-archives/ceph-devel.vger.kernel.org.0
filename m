Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E09A168B98
	for <lists+ceph-devel@lfdr.de>; Sat, 22 Feb 2020 02:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbgBVBgm (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 21 Feb 2020 20:36:42 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:24560 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726842AbgBVBgm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 21 Feb 2020 20:36:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582335400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JsWg+vf3Djfm8thf/NgIu9UDU/7qs5bEOI8Tco8qdMQ=;
        b=KeZZX6UJA6Ac8/dYWONF1CgOY6YHIadSZ+4CvBfHS7QPRQCUqXr8nrww+K3DwJaqUZVIpc
        u8i+vW4yYYtX+xKO3J1jz5Op1Emn4MPusAPt8WBtrygzu0ZxZSsQm4qJX2AJm+fhAdhz72
        wAw+l/SsP/Z0kvJhTZPC5Cm5JNsiHh4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-mOGkPahXMk-mR9kae5CIMg-1; Fri, 21 Feb 2020 20:36:39 -0500
X-MC-Unique: mOGkPahXMk-mR9kae5CIMg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25E61189F760;
        Sat, 22 Feb 2020 01:36:38 +0000 (UTC)
Received: from [10.72.12.94] (ovpn-12-94.pek2.redhat.com [10.72.12.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7683927094;
        Sat, 22 Feb 2020 01:36:33 +0000 (UTC)
Subject: Re: [PATCH v8 5/5] ceph: add global metadata perf metric support
From:   Xiubo Li <xiubli@redhat.com>
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Sage Weil <sage@redhat.com>, "Yan, Zheng" <zyan@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200221070556.18922-1-xiubli@redhat.com>
 <20200221070556.18922-6-xiubli@redhat.com>
 <68e496bca563ed6439c16f0de04d7daeb17f718a.camel@kernel.org>
 <CAOi1vP92XUaOfQ_xJFZDXuH4r9D07fW6ckEyd2csr7EhUSRkpg@mail.gmail.com>
 <8d977d6a-da80-5900-aead-395b9b4eaa76@redhat.com>
Message-ID: <27ce72e5-1be4-a6ed-1613-fc7febaa7dcf@redhat.com>
Date:   Sat, 22 Feb 2020 09:36:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <8d977d6a-da80-5900-aead-395b9b4eaa76@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/22 9:20, Xiubo Li wrote:
> On 2020/2/21 22:56, Ilya Dryomov wrote:
>> On Fri, Feb 21, 2020 at 1:03 PM Jeff Layton <jlayton@kernel.org> wrote=
:
>>> On Fri, 2020-02-21 at 02:05 -0500, xiubli@redhat.com wrote:
>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>
>>>> It will calculate the latency for the metedata requests, which only
>>>> include the time cousumed by network and the ceph.
>>>>
>>> "and the ceph MDS" ?
>>>
>>>> item=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total sum=
_lat(us)=C2=A0=C2=A0=C2=A0=C2=A0 avg_lat(us)
>>>> -----------------------------------------------------
>>>> metadata=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 113=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 220000=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 1946
>>>>
>>>> URL: https://tracker.ceph.com/issues/43215
>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>> ---
>>>> =C2=A0 fs/ceph/debugfs.c=C2=A0=C2=A0=C2=A0 |=C2=A0 6 ++++++
>>>> =C2=A0 fs/ceph/mds_client.c | 20 ++++++++++++++++++++
>>>> =C2=A0 fs/ceph/metric.h=C2=A0=C2=A0=C2=A0=C2=A0 | 13 +++++++++++++
>>>> =C2=A0 3 files changed, 39 insertions(+)
>>>>
>>>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>>>> index 464bfbdb970d..60f3e307fca1 100644
>>>> --- a/fs/ceph/debugfs.c
>>>> +++ b/fs/ceph/debugfs.c
>>>> @@ -146,6 +146,12 @@ static int metric_show(struct seq_file *s,=20
>>>> void *p)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 avg =3D total ? sum / total : 0=
;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s, "%-14s%-12lld%-16=
lld%lld\n", "write", total,=20
>>>> sum, avg);
>>>>
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 total =3D percpu_counter_sum(&mdsc->metric=
.total_metadatas);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 sum =3D percpu_counter_sum(&mdsc->metric.m=
etadata_latency_sum);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 sum =3D jiffies_to_usecs(sum);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 avg =3D total ? sum / total : 0;
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s, "%-14s%-12lld%-16lld%lld\n",=
 "metadata", total,=20
>>>> sum, avg);
>>>> +
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s, "\n");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s, "item=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total miss=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hit\n");
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s,=20
>>>> "-------------------------------------------------\n");
>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>> index 0a3447966b26..3e792eca6af7 100644
>>>> --- a/fs/ceph/mds_client.c
>>>> +++ b/fs/ceph/mds_client.c
>>>> @@ -3017,6 +3017,12 @@ static void handle_reply(struct=20
>>>> ceph_mds_session *session, struct ceph_msg *msg)
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* kick calling process */
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 complete_request(mdsc, req);
>>>> +
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 if (!result || result =3D=3D -ENOENT) {
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 s64 latency =3D jiffies - req->r_started;
>>>> +
>>>> + ceph_update_metadata_latency(&mdsc->metric, latency);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> Should we add an r_end_stamp field to the mds request struct and use
>>> that to calculate this? Many jiffies may have passed between the repl=
y
>>> coming in and this point. If you really want to measure the latency=20
>>> that
>>> would be more accurate, I think.
>> Yes, capturing it after invoking the callback is inconsistent
>> with what is done for OSD requests (the new r_end_stamp is set in
>> finish_request()).
>>
>> It looks like this is the only place where MDS r_end_stamp would be
>> needed, so perhaps just move this before complete_request() call?
>
> Currently for the OSD requests, they are almost in the same place=20
> where at the end of the handle_reply.
>
> If we don't want to calculate the consumption by the most of=20
> handle_reply code, we may set the r_end_stamp in the begin of it for=20
> both OSD/MDS requests ?
>
> I'm thinking since in the handle_reply, it may also wait for the mutex=20
> locks and then sleeps, so move the r_end_stamp to the beginning should=20
> make sense...
>
Currently case: we are calculating the time took from OSD/MDS requests=20
creating until the handle_reply finishes.

Another case mentioned above: we should move the r_end_stamp to the=20
handle_reply beginning, move r_start_stamp just before the requesting=20
submitted.

Which one should be better ?

Thanks.

BRs


> Thanks
> BRs
>
>
>> Thanks,
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 Ilya
>>
>

