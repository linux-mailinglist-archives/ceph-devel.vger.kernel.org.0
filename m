Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC4915273E
	for <lists+ceph-devel@lfdr.de>; Wed,  5 Feb 2020 08:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgBEH5Y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 5 Feb 2020 02:57:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:51655 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725497AbgBEH5Y (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 5 Feb 2020 02:57:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580889442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uk+wiccPvTqhPVNsRd0KAD8YSjS1x/jJsnz4nCIEBME=;
        b=aX2HJ799LrkpFEUCQcfn48W0FFpiuamPBFdlc0PiiYHwx1iTZjP/EQ45WW1hnVQPk/oMxU
        /VN8wq6BW0ofki3DMMhZDJJi9fJm3ZUQdX2suq/tqoniglXhXF3y896R9gMWuWqnWx5vE3
        0Wd04D7d0tjEorGMgOxfs55P/iyWO2o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-383-8VkZwYWbPjaF445C1JdJBw-1; Wed, 05 Feb 2020 02:57:20 -0500
X-MC-Unique: 8VkZwYWbPjaF445C1JdJBw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82B1D801A00;
        Wed,  5 Feb 2020 07:57:19 +0000 (UTC)
Received: from [10.72.12.34] (ovpn-12-34.pek2.redhat.com [10.72.12.34])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D34A8212C;
        Wed,  5 Feb 2020 07:57:14 +0000 (UTC)
Subject: Re: [PATCH resend v5 02/11] ceph: add caps perf metric for each
 session
To:     Jeff Layton <jlayton@kernel.org>, idryomov@gmail.com,
        zyan@redhat.com
Cc:     sage@redhat.com, pdonnell@redhat.com, ceph-devel@vger.kernel.org
References: <20200129082715.5285-1-xiubli@redhat.com>
 <20200129082715.5285-3-xiubli@redhat.com>
 <a456a29671efa7a94a955bc8f1655bb042dbf13d.camel@kernel.org>
 <c60f2ad9-1b33-04d5-8b65-e4205880b345@redhat.com>
 <44f8f32e04b3fba2c6e444ba079cfd14ea180318.camel@kernel.org>
 <6d7f3509-80cc-4ff6-866a-09afde79309a@redhat.com>
 <a6065c51-10fc-e4de-aae4-1401ef7ec998@redhat.com>
 <991c69a47eada14099696d93e12cfe85750d2267.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <8d2b510b-2b3e-739f-799a-f9c387327863@redhat.com>
Date:   Wed, 5 Feb 2020 15:57:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <991c69a47eada14099696d93e12cfe85750d2267.camel@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2020/2/5 5:10, Jeff Layton wrote:
> On Fri, 2020-01-31 at 17:02 +0800, Xiubo Li wrote:
>> On 2020/1/31 9:34, Xiubo Li wrote:
>>> On 2020/1/31 3:00, Jeffrey Layton wrote:
>>>
[...]
>> Currently in fuse client, for each inode it is its auth_cap->session's
>> responsibility to do all the cap hit/mis counting if it has a auth_cap=
,
>> or choose any one exist.
>>
>> Maybe this is one acceptable approach.
> Again, it's not clear to me what you're trying to measure.
>
> Typically, when you're counting hits and misses on a cache, what you
> care about is whether you had to wait to fill the cache in order to
> proceed. That means a lookup in the case of the dcache, but for this
> it's a cap request. If we have a miss, then we're going to ask a single
> MDS to resolve it.
>
> To me, it doesn't really make a lot of sense to track this at the
> session level since the client deals with cap hits and misses as a unio=
n
> of the caps for each session. Keeping per-superblock stats makes a lot
> more sense in my opinion.
>
> That makes this easy to determine too. You just logically OR all of the
> "issued" masks together (and maybe the implemented masks in requests
> that allow that), and check whether that covers the mask you need. If i=
t
> does, then you have a hit, if not, a miss.
>
> So, to be clear, what we'd be measuring in that case is cap cache check=
s
> per superblock. Is that what you're looking to measure with this?
>
The following is the new approach:

 =C2=A065 +/*
 =C2=A066 + * Counts the cap metric.
 =C2=A067 + *
 =C2=A068 + * This will try to traverse all the ci->i_caps, if we can
 =C2=A069 + * get all the cap 'mask' it will count the hit, or the mis.
 =C2=A070 + */
 =C2=A071 +void __ceph_caps_metric(struct ceph_inode_info *ci, int mask)
 =C2=A072 +{
 =C2=A073 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_mds_client *m=
dsc =3D
 =C2=A074 + ceph_sb_to_client(ci->vfs_inode.i_sb)->mdsc;
 =C2=A075 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct ceph_client_metric=
 *metric =3D &mdsc->metric;
 =C2=A076 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int issued;
 =C2=A077 +
 =C2=A078 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 lockdep_assert_held(&ci->=
i_ceph_lock);
 =C2=A079 +
 =C2=A080 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (mask <=3D 0)
 =C2=A081 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 return;
 =C2=A082 +
 =C2=A083 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 issued =3D __ceph_caps_is=
sued(ci, NULL);
 =C2=A084 +
 =C2=A085 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ((mask & issued) =3D=3D=
 mask)
 =C2=A086 + percpu_counter_inc(&metric->i_caps_hit);
 =C2=A087 +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 else
 =C2=A088 + percpu_counter_inc(&metric->i_caps_mis);
 =C2=A089 +}
 =C2=A090 +

The cap hit/mis metric are per-superblock, just like the others.

Thanks.

