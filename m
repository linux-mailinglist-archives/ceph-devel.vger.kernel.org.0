Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF4E17D226
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Mar 2020 08:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgCHHFn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 8 Mar 2020 03:05:43 -0400
Received: from pv50p00im-zteg10011401.me.com ([17.58.6.41]:49912 "EHLO
        pv50p00im-zteg10011401.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725854AbgCHHFn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 8 Mar 2020 03:05:43 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Mar 2020 03:05:43 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=me.com; s=1a1hai;
        t=1583650728; bh=c99mhR7KjOLOjdnPnFV5nAXfB49rhguZSbk1FcK6GrY=;
        h=Content-Type:Subject:From:Date:Message-Id:To;
        b=A1UtKZ0OcLO/utAn3BJ/ehlkwpIVSey6ps6iaiSO/coAupMhOudEuYL9wJFCA3hnC
         Ge4grjpJ0h7OyiH9b2MT0ed5Daqx9tXgotXPuNT4rowVFSIwj3m3HNTL00NLeBZIV+
         Nz6EovazAyN3g5HhFNbelF5LQBqrwOSh8HQdSKqhJdJqzp2bqZCF0n/jx2GpOZrArz
         zn6hwXHEOVQle1ZJO9zSvlzKotFIbq0KNysV9cvUMHwkZ0FEkm2MjG3nQTDl2jdwsU
         eBYwSnlkjuU64Y5LRVlsuIX63pHqw/UwA/x+9ZE7O1OZ6AtM8J3o/cbplSOQJTvsff
         mEcmahqkKcwjg==
Received: from [127.0.0.1] (n112120205186.netvigator.com [112.120.205.186])
        by pv50p00im-zteg10011401.me.com (Postfix) with ESMTPSA id B2CD1900215;
        Sun,  8 Mar 2020 06:58:45 +0000 (UTC)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: [ceph-users] ceph rbd volumes/images IO details
From:   XuYun <yunxu@me.com>
In-Reply-To: <CANA9Uk5eR41ZBYU_XGpgQoLwO8MnGTFuu6L+OKKvEBhs2YXCiA@mail.gmail.com>
Date:   Sun, 8 Mar 2020 14:58:42 +0800
Cc:     ceph-users <ceph-users@lists.ceph.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Brad Hubbard <bhubbard@redhat.com>,
        Robert LeBlanc <robert@leblancnet.us>,
        ceph-users <ceph-users@ceph.com>,
        Ceph Community <ceph-community@lists.ceph.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <B6D7DD2C-7F32-40D0-A24B-CE955B33438F@me.com>
References: <CANA9Uk54Ygo98sjozbU_HcAGjocSV2ui=-=imrDTCpdLOHhx6Q@mail.gmail.com>
 <CANA9Uk5eR41ZBYU_XGpgQoLwO8MnGTFuu6L+OKKvEBhs2YXCiA@mail.gmail.com>
To:     M Ranga Swami Reddy <swamireddy@gmail.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2020-03-08_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011 mlxscore=0
 mlxlogscore=673 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-2003080054
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

You can enable prometheus module of mgr if you are running Nautilus.

> 2020=E5=B9=B43=E6=9C=888=E6=97=A5 =E4=B8=8A=E5=8D=882:15=EF=BC=8CM =
Ranga Swami Reddy <swamireddy@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, Mar 6, 2020 at 1:06 AM M Ranga Swami Reddy =
<swamireddy@gmail.com>
> wrote:
>=20
>> Hello,
>> Can we get the IOPs of any rbd image/volume?
>>=20
>> For ex: I have created volumes via OpenStack Cinder. Want to know
>> the IOPs of these volumes.
>>=20
>> In general - we can get pool stats, but not seen the per volumes =
stats.
>>=20
>> Any hint here? Appreciated.
>>=20
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io

