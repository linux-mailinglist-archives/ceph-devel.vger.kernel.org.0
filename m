Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55703103584
	for <lists+ceph-devel@lfdr.de>; Wed, 20 Nov 2019 08:46:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfKTHqc (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 20 Nov 2019 02:46:32 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33569 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726406AbfKTHqb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 20 Nov 2019 02:46:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574235991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JAx6WSh+0qBl8sbGEHn7+GX2M3VDD6mdpcq6zrr/598=;
        b=MxoJC1CeAlBGYmqZWFLoKvNTzyJcpRPgpbjH0ztyuiSWO/6bf6OVW11Bhvw1iJL56fO22H
        Nv2lm2+3VW3Aqc8fBpTOnLMHUcl2QmFluR10VOZSy6Yx+GnLQkKxap7ExjGkbsOP/Tl1q7
        j3BXZzn8P/nmz+ZS6B0bL/ozhQmVpqE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-333-bDAKLm4OMeaapgloAd5QVw-1; Wed, 20 Nov 2019 02:46:27 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9B72218A07C2;
        Wed, 20 Nov 2019 07:46:26 +0000 (UTC)
Received: from [10.72.12.58] (ovpn-12-58.pek2.redhat.com [10.72.12.58])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0193B5D6C8;
        Wed, 20 Nov 2019 07:46:21 +0000 (UTC)
Subject: Re: [PATCH] ceph: check availability of mds cluster on mount after
 wait timeout
To:     Jeff Layton <jlayton@kernel.org>, sage@redhat.com,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org, zyan@redhat.com, pdonnell@redhat.com
References: <20191119130440.19384-1-xiubli@redhat.com>
 <d3650353d002964adb4b3f38335ff9e90a11a918.camel@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <919f08ef-b2b6-ecb5-603b-e25919116c4d@redhat.com>
Date:   Wed, 20 Nov 2019 15:46:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <d3650353d002964adb4b3f38335ff9e90a11a918.camel@kernel.org>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: bDAKLm4OMeaapgloAd5QVw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 2019/11/20 1:28, Jeff Layton wrote:
> On Tue, 2019-11-19 at 08:04 -0500, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> If all the MDS daemons are down for some reasons, and immediately
>> just before the kclient getting the new mdsmap the mount request is
>> fired out, it will be the request wait will timeout with -EIO.
>>
>> After this just check the mds cluster availability to give a friendly
>> hint to let the users check the MDS cluster status.
>>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   fs/ceph/mds_client.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
>> index a5163296d9d9..82a929084671 100644
>> --- a/fs/ceph/mds_client.c
>> +++ b/fs/ceph/mds_client.c
>> @@ -2712,6 +2712,9 @@ static int ceph_mdsc_wait_request(struct ceph_mds_=
client *mdsc,
>>   =09if (test_bit(CEPH_MDS_R_GOT_RESULT, &req->r_req_flags)) {
>>   =09=09err =3D le32_to_cpu(req->r_reply_info.head->result);
>>   =09} else if (err < 0) {
>> +=09=09if (!ceph_mdsmap_is_cluster_available(mdsc->mdsmap))
>> +=09=09=09pr_info("probably no mds server is up\n");
>> +
>>   =09=09dout("aborted request %lld with %d\n", req->r_tid, err);
>>  =20
>>   =09=09/*
> Probably? If they're all unavailable then definitely.

Currently, the ceph_mdsmap_is_cluster_available() is a bit buggy, and my=20
commit comment is not very correct and detail too.

In case:

# ceph fs dump
[...]

max_mds=C2=A0=C2=A0=C2=A0 3
in=C2=A0=C2=A0=C2=A0 0,1,2
up=C2=A0=C2=A0=C2=A0 {0=3D5139,1=3D4837,2=3D4985}
failed
damaged
stopped
data_pools=C2=A0=C2=A0=C2=A0 [2]
metadata_pool=C2=A0=C2=A0=C2=A0 1
inline_data=C2=A0=C2=A0=C2=A0 disabled
balancer
standby_count_wanted=C2=A0=C2=A0=C2=A0 1
[mds.a{0:5139} state up:active seq 7 laggy since=20
2019-11-20T01:04:13.040701-0500 addr v1:192.168.195.165:6813/2514516359]
[mds.b{1:4837} state up:active seq 6 addr=20
v1:192.168.195.165:6815/1921459709]
[mds.f{2:4985} state up:active seq 6 laggy since=20
2019-11-20T01:04:13.040685-0500 addr v1:192.168.195.165:6814/3730607184]

The m->m_num_laggy =3D=3D 2, but there still has one MDS in (up:active &=20
!laggy) state. In this case if the mount request choose the mds.a, there=20
still has the IO errors and failure. A better choice is that it can=20
choose the mds.b instead. Currently the=20
ceph_mdsmap_is_cluster_available() will just return false if there has=20
any MDS is laggy. I will fix it.

But even after fixing it, in a corner case that the Monitor may take a=20
while to update the laggy stat in mdsmap, at this time even though the=20
mds.a and mds.f have already crashed, but the state is still in=20
up:active without laggy, and if we do mount it may still choose the=20
mds.a, then it will fail too. But that do not mean that the MDS cluster=20
is not totally available. The "Probaly" here is in case of this corner case=
.

Will it make sense ?


>   Also, this is a
> pr_info message, so you probably need to prefix this with "ceph: ".

For the pr_info message it will add the module name as a prefix=20
automatically:

"<6>[23167.778366] ceph: probably no mds server is up"

This should be enough.


>
> Beyond that though, do we want to do this in what amounts to low-level
> infrastructure for MDS requests?
>
> I wonder if a warning like this would be better suited in
> open_root_dentry(). If ceph_mdsc_do_request returns -EIO [1] maybe have
> open_root_dentry do the check and pr_info?

Yeah, I was also thinking to bubble it up to the mount.ceph daemon in=20
userland, but still not sure which errno should it be, just -ETIMEOUT or=20
some others.


> [1]: Why does it use -EIO here anyway? Wouldn't -ETIMEOUT or something
> be better? Maybe the worry was that that error could bubble up to userla
> nd?

Yeah, I also have the same doubt, this is also the general metadata IO=20
paths for other operations, such as "create/lookup...".

And in the mount operation it really will bubble up to the mount.ceph in=20
userland.

Thanks

BRs

>

