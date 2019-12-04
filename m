Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061411120CD
	for <lists+ceph-devel@lfdr.de>; Wed,  4 Dec 2019 01:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbfLDA5P (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 3 Dec 2019 19:57:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:36329 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726060AbfLDA5P (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 3 Dec 2019 19:57:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575421033;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nCeSou7/BHWhZArOz4LwTAokn/+m1zRl+xV3FrUAkvE=;
        b=UdrU3U61lo0mnWYwOwO/7FMz9k8rZvcA0SvCEQz0q+GqONvIT0ma4zgTxKlSxxKp4z/hNW
        74mxFToXhln9GwoWdhkxKcZtv9rDJaUUfox7aKe7Se3yL/jDU59dG2nIapBIdByy9dIQwN
        pd+g1g/KF6nk66rsedbiGYtbAcs+rs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-i4HtW0zfPcOKemQ21OuKJQ-1; Tue, 03 Dec 2019 19:57:12 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 254CC800C76;
        Wed,  4 Dec 2019 00:57:11 +0000 (UTC)
Received: from [10.72.12.69] (ovpn-12-69.pek2.redhat.com [10.72.12.69])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63176600C8;
        Wed,  4 Dec 2019 00:57:06 +0000 (UTC)
Subject: Re: [PATCH v2] ceph: trigger the reclaim work once there has enough
 pending caps
To:     jlayton@kernel.org, zyan@redhat.com
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20191126123222.29510-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <7cdff2fd-1f17-4ad4-48cb-bf138cadf887@redhat.com>
Date:   Wed, 4 Dec 2019 08:57:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <20191126123222.29510-1-xiubli@redhat.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: i4HtW0zfPcOKemQ21OuKJQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Yan,

Good morning.

Is this version okay for you =EF=BC=9F

Addtional info:

The ceph_reclaim_caps_nr will be called with the parameter "nr" =3D=3D 1 or=
=20
2 for now and a larger count in future for some cases. The old code just=20
assumed that "nr=3D=3D1". So in corner case we may skip it many times=20
leaving large amount of cap reclaim pending in short time.


Thanks
BRs

On 2019/11/26 20:32, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> The nr in ceph_reclaim_caps_nr() is very possibly larger than 1,
> so we may miss it and the reclaim work couldn't triggered as expected.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>
> V2:
> - use a more graceful test.
>
>   fs/ceph/mds_client.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 2c92a1452876..109ec7e2ee7b 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2020,7 +2020,7 @@ void ceph_reclaim_caps_nr(struct ceph_mds_client *m=
dsc, int nr)
>   =09if (!nr)
>   =09=09return;
>   =09val =3D atomic_add_return(nr, &mdsc->cap_reclaim_pending);
> -=09if (!(val % CEPH_CAPS_PER_RELEASE)) {
> +=09if ((val % CEPH_CAPS_PER_RELEASE) < nr) {
>   =09=09atomic_set(&mdsc->cap_reclaim_pending, 0);
>   =09=09ceph_queue_cap_reclaim_work(mdsc);
>   =09}


