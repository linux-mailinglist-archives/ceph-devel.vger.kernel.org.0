Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FA7F18BEE0
	for <lists+ceph-devel@lfdr.de>; Thu, 19 Mar 2020 19:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgCSSBp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 19 Mar 2020 14:01:45 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:44937 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726934AbgCSSBo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 14:01:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584640900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KafWbAXyk5mV+WmMWell8PJL1CE1+u0GgiShpwUmhFc=;
        b=bwaiqgKgKqtZzPIu1DTxvHb3pLlLZSXRk1cd6SjM0DQTjl/EqaqwFGUXC6/tu+A8njhrg7
        z0+MyGNk8/sUv9zsUjFNbMcy2827GIlpgyxzC74rw1PAhrD4n7MvPE1MupDpq5Jasr695y
        7vmbnRqGmMHhnnl4CmQsIp8pPGlzDLc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-F7QAkz6iPC6Jg7S2zQ91mw-1; Thu, 19 Mar 2020 14:01:38 -0400
X-MC-Unique: F7QAkz6iPC6Jg7S2zQ91mw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E723F1005510;
        Thu, 19 Mar 2020 18:01:36 +0000 (UTC)
Received: from [10.72.12.253] (ovpn-12-253.pek2.redhat.com [10.72.12.253])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 72EBD6EFAB;
        Thu, 19 Mar 2020 18:01:31 +0000 (UTC)
Subject: Re: [PATCH v12 3/4] ceph: add read/write latency metric support
From:   Xiubo Li <xiubli@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     sage@redhat.com, idryomov@gmail.com, gfarnum@redhat.com,
        zyan@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <1584626812-21323-1-git-send-email-xiubli@redhat.com>
 <1584626812-21323-4-git-send-email-xiubli@redhat.com>
 <4f5fb881060ac868c836190b848270331ae20c4b.camel@kernel.org>
 <53ad3efb-809f-cfc1-aec7-31684fbc72aa@redhat.com>
Message-ID: <0fd904d1-af2a-d698-1116-26d38409c14a@redhat.com>
Date:   Fri, 20 Mar 2020 02:01:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <53ad3efb-809f-cfc1-aec7-31684fbc72aa@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/3/20 1:44, Xiubo Li wrote:
> On 2020/3/19 22:36, Jeff Layton wrote:
>> On Thu, 2020-03-19 at 10:06 -0400, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> Calculate the latency for OSD read requests. Add a new r_end_stamp
>>> field to struct ceph_osd_request that will hold the time of that
>>> the reply was received. Use that to calculate the RTT for each call,
>>> and divide the sum of those by number of calls to get averate RTT.
>>>
>>> Keep a tally of RTT for OSD writes and number of calls to track avera=
ge
>>> latency of OSD writes.
>>>
>>> URL: https://tracker.ceph.com/issues/43215
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>> =C2=A0 fs/ceph/addr.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 18 +++++++
>>> =C2=A0 fs/ceph/debugfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 60 +++++++++++++++++++++-
>>> =C2=A0 fs/ceph/file.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 26 +++++++=
+++
>>> =C2=A0 fs/ceph/metric.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 110=20
>>> ++++++++++++++++++++++++++++++++++++++++
>>> =C2=A0 fs/ceph/metric.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 23 +++++++++
>>> =C2=A0 include/linux/ceph/osd_client.h |=C2=A0=C2=A0 1 +
>>> =C2=A0 net/ceph/osd_client.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0=C2=A0 2 +
>>> =C2=A0 7 files changed, 239 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>> index 6f4678d..f359619 100644
>>> --- a/fs/ceph/addr.c
>>> +++ b/fs/ceph/addr.c
>>> @@ -216,6 +216,9 @@ static int ceph_sync_readpages(struct=20
>>> ceph_fs_client *fsc,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rc)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D ceph_os=
dc_wait_request(osdc, req);
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 ceph_update_read_latency(&fsc->mdsc->metri=
c, req->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->r_end_stamp, rc);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_osdc_put_request(req);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dout("readpages result %d\n", rc);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return rc;
>>> @@ -299,6 +302,7 @@ static int ceph_readpage(struct file *filp,=20
>>> struct page *page)
>>> =C2=A0 static void finish_read(struct ceph_osd_request *req)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D req->r_inode;
>>> +=C2=A0=C2=A0=C2=A0 struct ceph_fs_client *fsc =3D ceph_inode_to_clie=
nt(inode);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_osd_data *osd_data;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc =3D req->r_result <=3D 0 ? req-=
>r_result : 0;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int bytes =3D req->r_result >=3D 0 ? r=
eq->r_result : 0;
>>> @@ -336,6 +340,10 @@ static void finish_read(struct ceph_osd_request=20
>>> *req)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 put_page(page)=
;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bytes -=3D PAG=
E_SIZE;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ceph_update_read_latency(&fsc->mdsc->metric, req-=
>r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->r_end_stamp, rc);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(osd_data->pages);
>>> =C2=A0 }
>>> =C2=A0 @@ -643,6 +651,9 @@ static int ceph_sync_writepages(struct=20
>>> ceph_fs_client *fsc,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!rc)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D ceph_os=
dc_wait_request(osdc, req);
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 ceph_update_write_latency(&fsc->mdsc->metr=
ic,=20
>>> req->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->r_end_stamp, rc);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_osdc_put_request(req);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc =3D=3D 0)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rc =3D len;
>>> @@ -794,6 +805,9 @@ static void writepages_finish(struct=20
>>> ceph_osd_request *req)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_clear_err=
or_write(ci);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 ceph_update_write_latency(&fsc->mdsc->metr=
ic,=20
>>> req->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->r_end_stamp, rc);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * We lost the cache cap, need to=
 truncate the page before
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * it is unlocked, otherwise we'd=
 truncate it later in the
>>> @@ -1852,6 +1866,10 @@ int ceph_uninline_data(struct file *filp,=20
>>> struct page *locked_page)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D ceph_osdc_start_request(&fsc->=
client->osdc, req, false);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!err)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D ceph_o=
sdc_wait_request(&fsc->client->osdc, req);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ceph_update_write_latency(&fsc->mdsc->metric, req=
->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->r_end_stamp, err);
>>> +
>>> =C2=A0 out_put:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_osdc_put_request(req);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (err =3D=3D -ECANCELED)
>>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>>> index 66b9622..de07fdb 100644
>>> --- a/fs/ceph/debugfs.c
>>> +++ b/fs/ceph/debugfs.c
>>> @@ -7,6 +7,7 @@
>>> =C2=A0 #include <linux/ctype.h>
>>> =C2=A0 #include <linux/debugfs.h>
>>> =C2=A0 #include <linux/seq_file.h>
>>> +#include <linux/math64.h>
>>> =C2=A0 =C2=A0 #include <linux/ceph/libceph.h>
>>> =C2=A0 #include <linux/ceph/mon_client.h>
>>> @@ -124,13 +125,70 @@ static int mdsc_show(struct seq_file *s, void *=
p)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0 }
>>> =C2=A0 +static u64 get_avg(u64 *totalp, u64 *sump, spinlock_t *lockp,=
 u64=20
>>> *total)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u64 t, sum, avg =3D 0;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 spin_lock(lockp);
>>> +=C2=A0=C2=A0=C2=A0 t =3D *totalp;
>>> +=C2=A0=C2=A0=C2=A0 sum =3D *sump;
>>> +=C2=A0=C2=A0=C2=A0 spin_unlock(lockp);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (likely(t))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 avg =3D DIV64_U64_ROUND_C=
LOSEST(sum, t);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 *total =3D t;
>>> +=C2=A0=C2=A0=C2=A0 return avg;
>>> +}
>>> +
>>> +#define CEPH_METRIC_SHOW(name, total, avg, min, max, sq) {=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 u64 _total, _avg, _min, _max, _sq, _st, _re =3D 0=
;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 _avg =3D jiffies_to_usecs(avg);=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 _min =3D jiffies_to_usecs(min =3D=3D S64_MAX ? 0 =
: min); \
>>> +=C2=A0=C2=A0=C2=A0 _max =3D jiffies_to_usecs(max);=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 _total =3D total - 1;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 _sq =3D _total > 0 ? DIV64_U64_ROUND_CLOSEST(sq, =
_total) : 0;=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 _sq =3D jiffies_to_usecs(_sq);=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 _st =3D int_sqrt64(_sq);=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 if (_st > 0) {=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _re =3D 5 * (_sq - (_st *=
 _st));=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _re =3D _re > 0 ? _re - 1=
 : 0;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 _re =3D _st > 0 ? div64_s=
64(_re, _st) : 0;=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 }=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0 seq_printf(s, "%-14s%-12llu%-16llu%-16llu%-16llu%=
llu.%llu\n",=C2=A0=C2=A0=C2=A0 \
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 name, t=
otal, _avg, _min, _max, _st, _re);=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 \
>>> +}
>>> +
>>> =C2=A0 static int metric_show(struct seq_file *s, void *p)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_fs_client *fsc =3D s->priv=
ate;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_client *mdsc =3D fsc->=
mdsc;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_client_metric *m =3D &mdsc=
->metric;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int i, nr_caps =3D 0;
>>> -
>>> +=C2=A0=C2=A0=C2=A0 u64 total, avg, min, max, sq;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 seq_printf(s, "item=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 total=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 avg_la=
t(us)=20
>>> min_lat(us)=C2=A0=C2=A0=C2=A0=C2=A0 max_lat(us)=C2=A0=C2=A0=C2=A0=C2=A0=
 stdev(us)\n");
>>> +=C2=A0=C2=A0=C2=A0 seq_printf(s,=20
>>> "--------------------------------------------------------------------=
---------------\n");
>>> +
>>> +=C2=A0=C2=A0=C2=A0 avg =3D get_avg(&m->total_reads,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &m->read_latency_sum,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &m->read_latency_lock,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &total);
>>> +=C2=A0=C2=A0=C2=A0 min =3D atomic64_read(&m->read_latency_min);
>>> +=C2=A0=C2=A0=C2=A0 max =3D atomic64_read(&m->read_latency_max);
>>> +=C2=A0=C2=A0=C2=A0 sq =3D percpu_counter_sum(&m->read_latency_sq_sum=
);
>>> +=C2=A0=C2=A0=C2=A0 CEPH_METRIC_SHOW("read", total, avg, min, max, sq=
);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 avg =3D get_avg(&m->total_writes,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &m->write_latency_sum,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &m->write_latency_lock,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 &total);
>>> +=C2=A0=C2=A0=C2=A0 min =3D atomic64_read(&m->write_latency_min);
>>> +=C2=A0=C2=A0=C2=A0 max =3D atomic64_read(&m->write_latency_max);
>>> +=C2=A0=C2=A0=C2=A0 sq =3D percpu_counter_sum(&m->write_latency_sq_su=
m);
>>> +=C2=A0=C2=A0=C2=A0 CEPH_METRIC_SHOW("write", total, avg, min, max, s=
q);
>>> +
>>> +=C2=A0=C2=A0=C2=A0 seq_printf(s, "\n");
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s, "item=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 total miss=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 hit\n");
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 seq_printf(s,=20
>>> "-------------------------------------------------\n");
>>> =C2=A0 diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index 4a5ccbb..8e40022 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -906,6 +906,10 @@ static ssize_t ceph_sync_read(struct kiocb=20
>>> *iocb, struct iov_iter *to,
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D ceph_o=
sdc_start_request(osdc, req, false);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ret =3D ceph_osdc_wait_request(osdc, req);
>>> +
>>> + ceph_update_read_latency(&fsc->mdsc->metric, req->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->r_end_stamp, ret=
);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_osdc_put_=
request(req);
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i_size =
=3D i_size_read(inode);
>>> @@ -1044,6 +1048,8 @@ static void ceph_aio_complete_req(struct=20
>>> ceph_osd_request *req)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D req->r_inode;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_aio_request *aio_req =3D r=
eq->r_priv;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_osd_data *osd_data =3D=20
>>> osd_req_op_extent_osd_data(req, 0);
>>> +=C2=A0=C2=A0=C2=A0 struct ceph_fs_client *fsc =3D ceph_inode_to_clie=
nt(inode);
>>> +=C2=A0=C2=A0=C2=A0 struct ceph_client_metric *metric =3D &fsc->mdsc-=
>metric;
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(osd_data->type !=3D CEPH=
_OSD_DATA_TYPE_BVECS);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(!osd_data->num_bvecs);
>>> @@ -1051,6 +1057,16 @@ static void ceph_aio_complete_req(struct=20
>>> ceph_osd_request *req)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dout("ceph_aio_complete_req %p rc %d b=
ytes %u\n",
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 inode, r=
c, osd_data->bvec_pos.iter.bi_size);
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 /* r_start_stamp =3D=3D 0 means the reques=
t was not submitted */
>>> +=C2=A0=C2=A0=C2=A0 if (req->r_start_stamp) {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (aio_req->write)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
eph_update_write_latency(metric, req->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 req->r_end_stamp, rc);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
eph_update_read_latency(metric, req->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 req->r_end_stamp, rc);
>>> +=C2=A0=C2=A0=C2=A0 }
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (rc =3D=3D -EOLDSNAPC) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_ai=
o_work *aio_work;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 BUG_ON(!aio_re=
q->write);
>>> @@ -1179,6 +1195,7 @@ static void ceph_aio_retry_work(struct=20
>>> work_struct *work)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct inode *inode =3D file_inode(fil=
e);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_inode_info *ci =3D ceph_in=
ode(inode);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_fs_client *fsc =3D ceph_in=
ode_to_client(inode);
>>> +=C2=A0=C2=A0=C2=A0 struct ceph_client_metric *metric =3D &fsc->mdsc-=
>metric;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_vino vino;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_osd_request *req;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct bio_vec *bvecs;
>>> @@ -1295,6 +1312,13 @@ static void ceph_aio_retry_work(struct=20
>>> work_struct *work)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (write)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
eph_update_write_latency(metric, req->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 req->r_end_stamp, ret);
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 c=
eph_update_read_latency(metric, req->r_start_stamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
 req->r_end_stamp, ret);
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 size =3D i_siz=
e_read(inode);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!write) {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 if (ret =3D=3D -ENOENT)
>>> @@ -1466,6 +1490,8 @@ static void ceph_aio_retry_work(struct=20
>>> work_struct *work)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 ret =3D ceph_osdc_wait_request(&fsc->client->osdc, req);
>>> =C2=A0 + ceph_update_write_latency(&fsc->mdsc->metric, req->r_start_s=
tamp,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 req->r_end_stam=
p, ret);
>>> =C2=A0 out:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ceph_osdc_put_=
request(req);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret !=3D 0=
) {
>>> diff --git a/fs/ceph/metric.c b/fs/ceph/metric.c
>>> index 2a4b739..6cb64fb 100644
>>> --- a/fs/ceph/metric.c
>>> +++ b/fs/ceph/metric.c
>>> @@ -2,6 +2,7 @@
>>> =C2=A0 =C2=A0 #include <linux/types.h>
>>> =C2=A0 #include <linux/percpu_counter.h>
>>> +#include <linux/math64.h>
>>> =C2=A0 =C2=A0 #include "metric.h"
>>> =C2=A0 @@ -29,8 +30,32 @@ int ceph_metric_init(struct ceph_client_met=
ric *m)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (ret)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_i_cap=
s_mis;
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 ret =3D percpu_counter_init(&m->read_laten=
cy_sq_sum, 0,=20
>>> GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_read_latency_sq_=
sum;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 atomic64_set(&m->read_latency_min, S64_MAX);
>>> +=C2=A0=C2=A0=C2=A0 atomic64_set(&m->read_latency_max, 0);
>>> +=C2=A0=C2=A0=C2=A0 spin_lock_init(&m->read_latency_lock);
>>> +=C2=A0=C2=A0=C2=A0 m->total_reads =3D 0;
>>> +=C2=A0=C2=A0=C2=A0 m->read_latency_sum =3D 0;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 ret =3D percpu_counter_init(&m->write_latency_sq_=
sum, 0,=20
>>> GFP_KERNEL);
>>> +=C2=A0=C2=A0=C2=A0 if (ret)
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto err_write_latency_sq=
_sum;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 atomic64_set(&m->write_latency_min, S64_MAX);
>>> +=C2=A0=C2=A0=C2=A0 atomic64_set(&m->write_latency_max, 0);
>>> +=C2=A0=C2=A0=C2=A0 spin_lock_init(&m->write_latency_lock);
>>> +=C2=A0=C2=A0=C2=A0 m->total_writes =3D 0;
>>> +=C2=A0=C2=A0=C2=A0 m->write_latency_sum =3D 0;
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return 0;
>>> =C2=A0 +err_write_latency_sq_sum:
>>> +=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&m->read_latency_sq_sum);
>>> +err_read_latency_sq_sum:
>>> +=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&m->i_caps_mis);
>>> =C2=A0 err_i_caps_mis:
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&m->i_caps_hit)=
;
>>> =C2=A0 err_i_caps_hit:
>>> @@ -46,8 +71,93 @@ void ceph_metric_destroy(struct=20
>>> ceph_client_metric *m)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (!m)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>> =C2=A0 + percpu_counter_destroy(&m->write_latency_sq_sum);
>>> +=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&m->read_latency_sq_sum);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&m->i_caps_mis)=
;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&m->i_caps_hit)=
;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&m->d_lease_mis=
);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_destroy(&m->d_lease_hit=
);
>>> =C2=A0 }
>>> +
>>> +static inline void __update_min_latency(atomic64_t *min, unsigned=20
>>> long lat)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u64 cur, old;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 cur =3D atomic64_read(min);
>>> +=C2=A0=C2=A0=C2=A0 do {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 old =3D cur;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (likely(lat >=3D old))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
reak;
>>> +=C2=A0=C2=A0=C2=A0 } while (unlikely((cur =3D atomic64_cmpxchg(min, =
old, lat)) !=3D=20
>>> old));
>>> +}
>>> +
>>> +static inline void __update_max_latency(atomic64_t *max, unsigned=20
>>> long lat)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u64 cur, old;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 cur =3D atomic64_read(max);
>>> +=C2=A0=C2=A0=C2=A0 do {
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 old =3D cur;
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (likely(lat <=3D old))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 b=
reak;
>>> +=C2=A0=C2=A0=C2=A0 } while (unlikely((cur =3D atomic64_cmpxchg(max, =
old, lat)) !=3D=20
>>> old));
>>> +}
>>> +
>>> +static inline void __update_avg_and_sq(u64 *totalp, u64 *lsump,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct pe=
rcpu_counter *sq_sump,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 spinlock_=
t *lockp, unsigned long lat)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 u64 total, avg, sq, lsum;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 spin_lock(lockp);
>>> +=C2=A0=C2=A0=C2=A0 total =3D ++(*totalp);
>>> +=C2=A0=C2=A0=C2=A0 *lsump +=3D lat;
>>> +=C2=A0=C2=A0=C2=A0 lsum =3D *lsump;
>>> +=C2=A0=C2=A0=C2=A0 spin_unlock(lockp);
>
> For each read/write/metadata latency updating,=C2=A0 I am trying to jus=
t=20
> make the critical code as small as possible here.
>
>
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (unlikely(total =3D=3D 1))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 /* the sq is (lat - old_avg) * (lat - new_avg) */
>>> +=C2=A0=C2=A0=C2=A0 avg =3D DIV64_U64_ROUND_CLOSEST((lsum - lat), (to=
tal - 1));
>>> +=C2=A0=C2=A0=C2=A0 sq =3D lat - avg;
>>> +=C2=A0=C2=A0=C2=A0 avg =3D DIV64_U64_ROUND_CLOSEST(lsum, total);
>>> +=C2=A0=C2=A0=C2=A0 sq =3D sq * (lat - avg);
>>> +=C2=A0=C2=A0=C2=A0 percpu_counter_add(sq_sump, sq);
>
> IMO, the percpu_counter could bring us benefit without locks, which=20
> will do many div/muti many times and will take some longer time on=20
> computing the sq.
>
>
>>> +}
>>> +
>>> +void ceph_update_read_latency(struct ceph_client_metric *m,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r_start,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r_end,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 unsigned long lat =3D r_end - r_start;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (unlikely(rc < 0 && rc !=3D -ENOENT && rc !=3D=
 -ETIMEDOUT))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 __update_min_latency(&m->read_latency_min, lat);
>>> +=C2=A0=C2=A0=C2=A0 __update_max_latency(&m->read_latency_max, lat);
>
> And also here to update the min/max without locks, but this should be=20
> okay to switch to u64 and under the locks.
>
> Thought ?
>
> If this makes sense, I will make the min/max to u64 type, and keep the=20
> sq_sum as the percpu. Or I will make them all to u64.
>
And also in the future, we may need to support and calculate all the=20
above perf in different IO sizes, like 4k/8k/16k/32k/.../64M.

If so, keep the min/max as atomic type and sq_sum as percpu type and do=20
them outside the spin lock should be better ?

Thanks

> Thanks.
>
>
>
>>> + __update_avg_and_sq(&m->total_reads, &m->read_latency_sum,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &m->read_latency_sq_sum,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &m->read_latency_lock,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 lat);
>>> +}
>>> +
>>> +void ceph_update_write_latency(struct ceph_client_metric *m,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r_start,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r_end,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc)
>>> +{
>>> +=C2=A0=C2=A0=C2=A0 unsigned long lat =3D r_end - r_start;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 if (unlikely(rc && rc !=3D -ETIMEDOUT))
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 __update_min_latency(&m->write_latency_min, lat);
>>> +=C2=A0=C2=A0=C2=A0 __update_max_latency(&m->write_latency_max, lat);
>>> +=C2=A0=C2=A0=C2=A0 __update_avg_and_sq(&m->total_writes, &m->write_l=
atency_sum,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &m->write_latency_sq_sum,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 &m->write_latency_lock,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 lat);
>>> +}
>>> diff --git a/fs/ceph/metric.h b/fs/ceph/metric.h
>>> index 098ee8a..c7eae56 100644
>>> --- a/fs/ceph/metric.h
>>> +++ b/fs/ceph/metric.h
>>> @@ -13,6 +13,20 @@ struct ceph_client_metric {
>>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct percpu_counter i_caps_hi=
t;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct percpu_counter i_caps_mis;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 struct percpu_counter read_latency_sq_sum;
>>> +=C2=A0=C2=A0=C2=A0 atomic64_t read_latency_min;
>>> +=C2=A0=C2=A0=C2=A0 atomic64_t read_latency_max;
>> I'd make the above 3 values be regular values and make them all use th=
e
>> read_latency_lock. Given that you're taking a lock anyway, it's more
>> efficient to just do all of the manipulation under a single spinlock
>> rather than fooling with atomic or percpu values. These are all almost
>> certainly going to be in the same cacheline anyway.
>>
>>> +=C2=A0=C2=A0=C2=A0 spinlock_t read_latency_lock;
>>> +=C2=A0=C2=A0=C2=A0 u64 total_reads;
>>> +=C2=A0=C2=A0=C2=A0 u64 read_latency_sum;
>>> +
>>> +=C2=A0=C2=A0=C2=A0 struct percpu_counter write_latency_sq_sum;
>>> +=C2=A0=C2=A0=C2=A0 atomic64_t write_latency_min;
>>> +=C2=A0=C2=A0=C2=A0 atomic64_t write_latency_max;
>>> +=C2=A0=C2=A0=C2=A0 spinlock_t write_latency_lock;
>>> +=C2=A0=C2=A0=C2=A0 u64 total_writes;
>>> +=C2=A0=C2=A0=C2=A0 u64 write_latency_sum;
>>> =C2=A0 };
>>> =C2=A0 =C2=A0 extern int ceph_metric_init(struct ceph_client_metric *=
m);
>>> @@ -27,4 +41,13 @@ static inline void ceph_update_cap_mis(struct=20
>>> ceph_client_metric *m)
>>> =C2=A0 {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_counter_inc(&m->i_caps_mis);
>>> =C2=A0 }
>>> +
>>> +extern void ceph_update_read_latency(struct ceph_client_metric *m,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r_start=
,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r_end,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc);
>>> +extern void ceph_update_write_latency(struct ceph_client_metric *m,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r=
_start,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r=
_end,
>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int rc);
>>> =C2=A0 #endif /* _FS_CEPH_MDS_METRIC_H */
>>> diff --git a/include/linux/ceph/osd_client.h=20
>>> b/include/linux/ceph/osd_client.h
>>> index 9d9f745..02ff3a3 100644
>>> --- a/include/linux/ceph/osd_client.h
>>> +++ b/include/linux/ceph/osd_client.h
>>> @@ -213,6 +213,7 @@ struct ceph_osd_request {
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* internal */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r_stamp;=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
/* jiffies, send or=20
>>> check time */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long r_start_stamp;=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* jiffies */
>>> +=C2=A0=C2=A0=C2=A0 unsigned long r_end_stamp;=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /* jiffies */
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int r_attempts;
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 u32 r_map_dne_bound;
>>> =C2=A0 diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>> index 998e26b..28e33e0 100644
>>> --- a/net/ceph/osd_client.c
>>> +++ b/net/ceph/osd_client.c
>>> @@ -2389,6 +2389,8 @@ static void finish_request(struct=20
>>> ceph_osd_request *req)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 WARN_ON(lookup_request_mc(&osdc->map_c=
hecks, req->r_tid));
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 dout("%s req %p tid %llu\n", __func__,=
 req, req->r_tid);
>>> =C2=A0 +=C2=A0=C2=A0=C2=A0 req->r_end_stamp =3D jiffies;
>>> +
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (req->r_osd)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unlink_request=
(req->r_osd, req);
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 atomic_dec(&osdc->num_requests);
>
>

