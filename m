Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC6114019A
	for <lists+ceph-devel@lfdr.de>; Fri, 17 Jan 2020 02:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388630AbgAQB4h (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Jan 2020 20:56:37 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:24245 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726741AbgAQB4h (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Jan 2020 20:56:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579226194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3YJ5oCV4yhqOhJUtaDoI1bx5fscmWaZOvyRK477LY6E=;
        b=VItBdbla/DuuNuazyJpP6iqvxg8Ta8/qBBig8HrmJLg8WJOoXbIGB7MTk90iZNP0lO6pRf
        pSRWg85oOZPKvU8wouaBMidgNH1TBCCwo6Nuowx3CCwCrxo5n/9yP/e0gz6XBmUaKbTR88
        Ze/Cx25UPefRUfO9+pAtaq/PqExcHms=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-TNd8GAS1OsOu2mP9E3-nLA-1; Thu, 16 Jan 2020 20:56:33 -0500
X-MC-Unique: TNd8GAS1OsOu2mP9E3-nLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 012A0800D48;
        Fri, 17 Jan 2020 01:56:32 +0000 (UTC)
Received: from [10.72.12.49] (ovpn-12-49.pek2.redhat.com [10.72.12.49])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E24DD811E2;
        Fri, 17 Jan 2020 01:56:26 +0000 (UTC)
Subject: Re: [PATCH v3 4/8] ceph: add global write latency metric support
To:     Ilya Dryomov <idryomov@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <20200115034444.14304-1-xiubli@redhat.com>
 <20200115034444.14304-5-xiubli@redhat.com>
 <18a2177615ab26ff546601a1a5baae1798608bdd.camel@kernel.org>
 <CAOi1vP8zLvH4tXVwYOcFDkvnfaWAPuTqwruAZAjjGQJzs1p-Jg@mail.gmail.com>
 <cb4aaae360079a0b2cf0f2c9d24ffc8b4ae9dde3.camel@kernel.org>
 <CAOi1vP-ZE0ZZ14Cg0pqVYLh8Ta5kJrCjtFUJ70ViMiCN+MNtXQ@mail.gmail.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f44eec0e-a032-0fa6-5f5c-16281760c75c@redhat.com>
Date:   Fri, 17 Jan 2020 09:56:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-ZE0ZZ14Cg0pqVYLh8Ta5kJrCjtFUJ70ViMiCN+MNtXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/1/17 3:36, Ilya Dryomov wrote:
> On Thu, Jan 16, 2020 at 5:31 PM Jeff Layton <jlayton@kernel.org> wrote:
>> On Thu, 2020-01-16 at 15:46 +0100, Ilya Dryomov wrote:
>>> On Thu, Jan 16, 2020 at 3:14 PM Jeff Layton <jlayton@kernel.org> wrot=
e:
>>>> On Tue, 2020-01-14 at 22:44 -0500, xiubli@redhat.com wrote:
>>>>> From: Xiubo Li <xiubli@redhat.com>
>>>>>
>>>>> item          total       sum_lat(us)     avg_lat(us)
>>>>> -----------------------------------------------------
>>>>> write         222         5287750000      23818693
>>>>>
>>>>> URL: https://tracker.ceph.com/issues/43215
>>>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>>>> ---
>>>>>   fs/ceph/addr.c                  | 23 +++++++++++++++++++++--
>>>>>   fs/ceph/debugfs.c               |  8 ++++++++
>>>>>   fs/ceph/file.c                  |  9 +++++++++
>>>>>   fs/ceph/mds_client.c            | 20 ++++++++++++++++++++
>>>>>   fs/ceph/mds_client.h            |  6 ++++++
>>>>>   include/linux/ceph/osd_client.h |  3 ++-
>>>>>   net/ceph/osd_client.c           |  9 ++++++++-
>>>>>   7 files changed, 74 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
>>>>> index 2a32f731f92a..b667ddaa6623 100644
>>>>> --- a/fs/ceph/addr.c
>>>>> +++ b/fs/ceph/addr.c
>>>>> @@ -598,12 +598,15 @@ static int writepage_nounlock(struct page *pa=
ge, struct writeback_control *wbc)
>>>>>        loff_t page_off =3D page_offset(page);
>>>>>        int err, len =3D PAGE_SIZE;
>>>>>        struct ceph_writeback_ctl ceph_wbc;
>>>>> +     struct ceph_client_metric *metric;
>>>>> +     s64 latency;
>>>>>
>>>>>        dout("writepage %p idx %lu\n", page, page->index);
>>>>>
>>>>>        inode =3D page->mapping->host;
>>>>>        ci =3D ceph_inode(inode);
>>>>>        fsc =3D ceph_inode_to_client(inode);
>>>>> +     metric =3D &fsc->mdsc->metric;
>>>>>
>>>>>        /* verify this is a writeable snap context */
>>>>>        snapc =3D page_snap_context(page);
>>>>> @@ -645,7 +648,11 @@ static int writepage_nounlock(struct page *pag=
e, struct writeback_control *wbc)
>>>>>                                   &ci->i_layout, snapc, page_off, l=
en,
>>>>>                                   ceph_wbc.truncate_seq,
>>>>>                                   ceph_wbc.truncate_size,
>>>>> -                                &inode->i_mtime, &page, 1);
>>>>> +                                &inode->i_mtime, &page, 1,
>>>>> +                                &latency);
>>>>> +     if (latency)
>>>>> +             ceph_mdsc_update_write_latency(metric, latency);
>>>>> +
>>>>>        if (err < 0) {
>>>>>                struct writeback_control tmp_wbc;
>>>>>                if (!wbc)
>>>>> @@ -707,6 +714,8 @@ static void writepages_finish(struct ceph_osd_r=
equest *req)
>>>>>   {
>>>>>        struct inode *inode =3D req->r_inode;
>>>>>        struct ceph_inode_info *ci =3D ceph_inode(inode);
>>>>> +     struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
>>>>> +     struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
>>>>>        struct ceph_osd_data *osd_data;
>>>>>        struct page *page;
>>>>>        int num_pages, total_pages =3D 0;
>>>>> @@ -714,7 +723,6 @@ static void writepages_finish(struct ceph_osd_r=
equest *req)
>>>>>        int rc =3D req->r_result;
>>>>>        struct ceph_snap_context *snapc =3D req->r_snapc;
>>>>>        struct address_space *mapping =3D inode->i_mapping;
>>>>> -     struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
>>>>>        bool remove_page;
>>>>>
>>>>>        dout("writepages_finish %p rc %d\n", inode, rc);
>>>>> @@ -783,6 +791,11 @@ static void writepages_finish(struct ceph_osd_=
request *req)
>>>>>                             ceph_sb_to_client(inode->i_sb)->wb_page=
vec_pool);
>>>>>        else
>>>>>                kfree(osd_data->pages);
>>>>> +
>>>>> +     if (!rc) {
>>>>> +             s64 latency =3D jiffies - req->r_start_stamp;
>>>>> +             ceph_mdsc_update_write_latency(metric, latency);
>>>>> +     }
>>>>>        ceph_osdc_put_request(req);
>>>>>   }
>>>>>
>>>>> @@ -1675,6 +1688,7 @@ int ceph_uninline_data(struct file *filp, str=
uct page *locked_page)
>>>>>        struct inode *inode =3D file_inode(filp);
>>>>>        struct ceph_inode_info *ci =3D ceph_inode(inode);
>>>>>        struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
>>>>> +     struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
>>>>>        struct ceph_osd_request *req;
>>>>>        struct page *page =3D NULL;
>>>>>        u64 len, inline_version;
>>>>> @@ -1786,6 +1800,11 @@ int ceph_uninline_data(struct file *filp, st=
ruct page *locked_page)
>>>>>        err =3D ceph_osdc_start_request(&fsc->client->osdc, req, fal=
se);
>>>>>        if (!err)
>>>>>                err =3D ceph_osdc_wait_request(&fsc->client->osdc, r=
eq);
>>>>> +
>>>>> +     if (!err || err =3D=3D -ETIMEDOUT) {
>>>>> +             s64 latency =3D jiffies - req->r_start_stamp;
>>>>> +             ceph_mdsc_update_write_latency(metric, latency);
>>>>> +     }
>>>>>   out_put:
>>>>>        ceph_osdc_put_request(req);
>>>>>        if (err =3D=3D -ECANCELED)
>>>>> diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
>>>>> index 8200bf025ccd..3fdb15af0a83 100644
>>>>> --- a/fs/ceph/debugfs.c
>>>>> +++ b/fs/ceph/debugfs.c
>>>>> @@ -142,6 +142,14 @@ static int metric_show(struct seq_file *s, voi=
d *p)
>>>>>        seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "read",
>>>>>                   total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
>>>>>
>>>>> +     spin_lock(&mdsc->metric.write_lock);
>>>>> +     total =3D atomic64_read(&mdsc->metric.total_writes),
>>>>> +     sum =3D timespec64_to_ns(&mdsc->metric.write_latency_sum);
>>>>> +     spin_unlock(&mdsc->metric.write_lock);
>>>>> +     avg =3D total ? sum / total : 0;
>>>>> +     seq_printf(s, "%-14s%-12lld%-16lld%lld\n", "write",
>>>>> +                total, sum / NSEC_PER_USEC, avg / NSEC_PER_USEC);
>>>>> +
>>>>>        seq_printf(s, "\n");
>>>>>        seq_printf(s, "item          total           miss           =
 hit\n");
>>>>>        seq_printf(s, "---------------------------------------------=
----\n");
>>>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>>>> index 797d4d224223..70530ac798ac 100644
>>>>> --- a/fs/ceph/file.c
>>>>> +++ b/fs/ceph/file.c
>>>>> @@ -822,6 +822,8 @@ static void ceph_aio_complete_req(struct ceph_o=
sd_request *req)
>>>>>                        op =3D &req->r_ops[i];
>>>>>                        if (op->op =3D=3D CEPH_OSD_OP_READ)
>>>>>                                ceph_mdsc_update_read_latency(metric=
, latency);
>>>>> +                     else if (op->op =3D=3D CEPH_OSD_OP_WRITE && r=
c !=3D -ENOENT)
>>>>> +                             ceph_mdsc_update_write_latency(metric=
, latency);
>>>>>                }
>>>>>        }
>>>>>
>>>>> @@ -1075,6 +1077,8 @@ ceph_direct_read_write(struct kiocb *iocb, st=
ruct iov_iter *iter,
>>>>>
>>>>>                        if (!write)
>>>>>                                ceph_mdsc_update_read_latency(metric=
, latency);
>>>>> +                     else if (write && ret !=3D -ENOENT)
>>>>> +                             ceph_mdsc_update_write_latency(metric=
, latency);
>>>>>                }
>>>>>
>>>>>                size =3D i_size_read(inode);
>>>>> @@ -1163,6 +1167,7 @@ ceph_sync_write(struct kiocb *iocb, struct io=
v_iter *from, loff_t pos,
>>>>>        struct inode *inode =3D file_inode(file);
>>>>>        struct ceph_inode_info *ci =3D ceph_inode(inode);
>>>>>        struct ceph_fs_client *fsc =3D ceph_inode_to_client(inode);
>>>>> +     struct ceph_client_metric *metric =3D &fsc->mdsc->metric;
>>>>>        struct ceph_vino vino;
>>>>>        struct ceph_osd_request *req;
>>>>>        struct page **pages;
>>>>> @@ -1248,6 +1253,10 @@ ceph_sync_write(struct kiocb *iocb, struct i=
ov_iter *from, loff_t pos,
>>>>>                if (!ret)
>>>>>                        ret =3D ceph_osdc_wait_request(&fsc->client-=
>osdc, req);
>>>>>
>>>>> +             if (!ret || ret =3D=3D -ETIMEDOUT) {
>>>>> +                     s64 latency =3D jiffies - req->r_start_stamp;
>>>>> +                     ceph_mdsc_update_write_latency(metric, latenc=
y);
>>>>> +             }
>>>>>   out:
>>>>>                ceph_osdc_put_request(req);
>>>>>                if (ret !=3D 0) {
>>>>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>>>>> index dc2cda55a5a5..2569f9303c0c 100644
>>>>> --- a/fs/ceph/mds_client.c
>>>>> +++ b/fs/ceph/mds_client.c
>>>>> @@ -4112,6 +4112,22 @@ void ceph_mdsc_update_read_latency(struct ce=
ph_client_metric *m,
>>>>>        spin_unlock(&m->read_lock);
>>>>>   }
>>>>>
>>>>> +void ceph_mdsc_update_write_latency(struct ceph_client_metric *m,
>>>>> +                                 s64 latency)
>>>>> +{
>>>>> +     struct timespec64 ts;
>>>>> +
>>>>> +     if (!m)
>>>>> +             return;
>>>>> +
>>>>> +     jiffies_to_timespec64(latency, &ts);
>>>>> +
>>>>> +     spin_lock(&m->write_lock);
>>>>> +     atomic64_inc(&m->total_writes);
>>>>> +     m->write_latency_sum =3D timespec64_add(m->write_latency_sum,=
 ts);
>>>>> +     spin_unlock(&m->write_lock);
>>>>> +}
>>>>> +
>>>>>   /*
>>>>>    * delayed work -- periodically trim expired leases, renew caps w=
ith mds
>>>>>    */
>>>>> @@ -4212,6 +4228,10 @@ static int ceph_mdsc_metric_init(struct ceph=
_client_metric *metric)
>>>>>        memset(&metric->read_latency_sum, 0, sizeof(struct timespec6=
4));
>>>>>        atomic64_set(&metric->total_reads, 0);
>>>>>
>>>>> +     spin_lock_init(&metric->write_lock);
>>>>> +     memset(&metric->write_latency_sum, 0, sizeof(struct timespec6=
4));
>>>>> +     atomic64_set(&metric->total_writes, 0);
>>>>> +
>>>>>        return 0;
>>>>>   }
>>>>>
>>>>> diff --git a/fs/ceph/mds_client.h b/fs/ceph/mds_client.h
>>>>> index fee25b999c7c..0120357e7549 100644
>>>>> --- a/fs/ceph/mds_client.h
>>>>> +++ b/fs/ceph/mds_client.h
>>>>> @@ -370,6 +370,10 @@ struct ceph_client_metric {
>>>>>        spinlock_t              read_lock;
>>>>>        atomic64_t              total_reads;
>>>>>        struct timespec64       read_latency_sum;
>>>>> +
>>>>> +     spinlock_t              write_lock;
>>>>> +     atomic64_t              total_writes;
>>>>> +     struct timespec64       write_latency_sum;
>>>> Would percpu counters be better here? I mean it's not a _super_ high
>>>> performance codepath, but it's nice when stats gathering has very li=
ttle
>>>> overhead. It'd take up a bit more space, but it's not that much, and
>>>> there'd be no serialization between CPUs operating on different inod=
es.
>>>>
>>>>
>>>> To be clear, the latency you're measuring is request time to the OSD=
?
>>>>
>>>>>   };
>>>>>
>>>>>   /*
>>>>> @@ -556,4 +560,6 @@ extern int ceph_trim_caps(struct ceph_mds_clien=
t *mdsc,
>>>>>
>>>>>   extern void ceph_mdsc_update_read_latency(struct ceph_client_metr=
ic *m,
>>>>>                                          s64 latency);
>>>>> +extern void ceph_mdsc_update_write_latency(struct ceph_client_metr=
ic *m,
>>>>> +                                        s64 latency);
>>>>>   #endif
>>>>> diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/o=
sd_client.h
>>>>> index 43e4240d88e7..e73439d18f28 100644
>>>>> --- a/include/linux/ceph/osd_client.h
>>>>> +++ b/include/linux/ceph/osd_client.h
>>>>> @@ -524,7 +524,8 @@ extern int ceph_osdc_writepages(struct ceph_osd=
_client *osdc,
>>>>>                                u64 off, u64 len,
>>>>>                                u32 truncate_seq, u64 truncate_size,
>>>>>                                struct timespec64 *mtime,
>>>>> -                             struct page **pages, int nr_pages);
>>>>> +                             struct page **pages, int nr_pages,
>>>>> +                             s64 *latency);
>>>>>
>>>>>   int ceph_osdc_copy_from(struct ceph_osd_client *osdc,
>>>>>                        u64 src_snapid, u64 src_version,
>>>>> diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
>>>>> index 62eb758f2474..9f6833ab733c 100644
>>>>> --- a/net/ceph/osd_client.c
>>>>> +++ b/net/ceph/osd_client.c
>>>>> @@ -5285,12 +5285,16 @@ int ceph_osdc_writepages(struct ceph_osd_cl=
ient *osdc, struct ceph_vino vino,
>>>>>                         u64 off, u64 len,
>>>>>                         u32 truncate_seq, u64 truncate_size,
>>>>>                         struct timespec64 *mtime,
>>>>> -                      struct page **pages, int num_pages)
>>>>> +                      struct page **pages, int num_pages,
>>>>> +                      s64 *latency)
>>>>>   {
>>>>>        struct ceph_osd_request *req;
>>>>>        int rc =3D 0;
>>>>>        int page_align =3D off & ~PAGE_MASK;
>>>>>
>>>>> +     if (latency)
>>>>> +             *latency =3D 0;
>>>>> +
>>>>>        req =3D ceph_osdc_new_request(osdc, layout, vino, off, &len,=
 0, 1,
>>>>>                                    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG=
_WRITE,
>>>>>                                    snapc, truncate_seq, truncate_si=
ze,
>>>>> @@ -5308,6 +5312,9 @@ int ceph_osdc_writepages(struct ceph_osd_clie=
nt *osdc, struct ceph_vino vino,
>>>>>        if (!rc)
>>>>>                rc =3D ceph_osdc_wait_request(osdc, req);
>>>>>
>>>>> +     if (latency && (!rc || rc =3D=3D -ETIMEDOUT))
>>>>> +             *latency =3D jiffies - req->r_start_stamp;
>>>>> +
>>>> Are you concerned at all with scheduling delays? Note that you're do=
ing
>>>> the latency calculation here which occurs in the task that is woken =
by
>>>> __complete_request. That won't necessarily wake up immediately on a =
busy
>>>> machine, so this measurement will include that delay as well.
>>>>
>>>> I wonder if we ought to add a r_end_stamp field to the req instead, =
and
>>>> grab jiffies in (e.g.) __complete_request. Then you could just fetch
>>>> that out and do the math.
>>> __complete_request() is a bit of a special case, putting it in
>>> finish_request() would work better.  It will still include some delay=
s,
>>> but then measuring the OSD service time on the client side is pretty
>>> much impossible to do precisely.
>>>
>> Yeah, that sounds better. This is a best-effort sort of thing, but let=
's
>> do make our best effort.

Yeah, the finish_request() can also include the case that when the=20
requests are timedout, and the timeout code will call the=20
finish_requst() too. The __complete_request() will not.


>>
>>>>>        ceph_osdc_put_request(req);
>>>>>        if (rc =3D=3D 0)
>>>>>                rc =3D len;
>>>> Ditto here on my earlier comment in the earlier email. Let's just tu=
rn
>>>> this into a ceph_osdc_writepages_start function and open-code the wa=
it
>>>> and latency calculation in writepage_nounlock().
>>> That's a good idea, but let's keep the existing name.  The non-blocki=
ng
>>> behavior should be the default -- I have most of the remaining blocki=
ng
>>> methods in libceph converted in a private branch for rbd exclusive-lo=
ck
>>> rewrite.
>>>
>> As a general rule, I like changing the name when a function's behavior
>> changes significantly like this, as that makes it harder to screw thin=
gs
>> up when selectively backporting patches.
>>
>> In this case, there's only a single caller of each, so I don't have a
>> strong objection, but I have been bitten by this before.
>>
>> It also might not hurt to move both ceph_osdc_readpages and
>> ceph_osdc_writepages into ceph.ko. Given that they're only called from
>> cephfs they probably belong there anyway.
> Yeah, they are definitely specific to ceph.ko.  They have always been
> in osd_client.c, but I think that is just an accident.  The "osdc" part
> of the name will need to go, making the argument moot ;)

So let move the ceph_osdc_readpages/ceph_osdc_writepages to ceph.ko.

Since they are all about sync read/write, then how about rename them to=20
ceph_sync_readpages/ceph_sync_writepages ? In addr.c there is already=20
has on func named=C2=A0 ceph_writepages_start(), to add "_sync_" and make=
 the=20
sync/async functions easier to distinguish ?

Thanks.


> Thanks,
>
>                  Ilya
>

