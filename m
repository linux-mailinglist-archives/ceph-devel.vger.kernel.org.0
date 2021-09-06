Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB349401AAA
	for <lists+ceph-devel@lfdr.de>; Mon,  6 Sep 2021 13:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbhIFLp1 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 6 Sep 2021 07:45:27 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34828 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231173AbhIFLpZ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 6 Sep 2021 07:45:25 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 186BXrJc036697;
        Mon, 6 Sep 2021 07:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=YDq2fdygf8Y3QfqeYgjO/iDMTPx1mMqDc6x9GEPkVK8=;
 b=rXGDkgyuwG12cXOP7sKpTlrDfxf78vS+ERlDVQCznYwY5Umu8fLmsvJUXjC5BHfSGofC
 mNZLMiKDL4Pej8yeE74rxKpkwA6ruFPgvcgdkod+CtyruxDbqBiM7l0TRHnXzBae4/kc
 gleUWs3TeQju2cuGcS33ONcK2nO9ltXSFCx/VXaqcgb8oytTbnYbaQHzPi5FqSrVVY+x
 FSQ0ordEbBK0kmS4GWXSfP4mo5ddON6BAOT/n5lSJ+/1sAR7UCL/FnPvnhXwNf5cRgkB
 X1h0P192iHYvBq71WsaqpcK+siTe0Tf9Ogc7eOakqhmdwAs6sGnyxW2fZUFNmf6ePqiG ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3awj5t0901-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 07:43:56 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 186BYkTj039013;
        Mon, 6 Sep 2021 07:43:55 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3awj5t08yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 07:43:55 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 186BhLge007528;
        Mon, 6 Sep 2021 11:43:53 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3av0e938eu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 06 Sep 2021 11:43:53 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 186BhnlL43975164
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 6 Sep 2021 11:43:49 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8747A4054;
        Mon,  6 Sep 2021 11:43:49 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36C25A405C;
        Mon,  6 Sep 2021 11:43:48 +0000 (GMT)
Received: from thinkpad (unknown [9.171.78.139])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Mon,  6 Sep 2021 11:43:48 +0000 (GMT)
Date:   Mon, 6 Sep 2021 13:43:46 +0200
From:   Gerald Schaefer <gerald.schaefer@linux.ibm.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Heiko Carstens <hca@linux.ibm.com>, axboe@kernel.dk,
        gregkh@linuxfoundation.org, chaitanya.kulkarni@wdc.com,
        atulgopinathan@gmail.com, hare@suse.de, maximlevitsky@gmail.com,
        oakad@yahoo.com, ulf.hansson@linaro.org, colin.king@canonical.com,
        shubhankarvk@gmail.com, baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hoeppner@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] s390/block/dcssblk: add error handling support for
 add_disk()
Message-ID: <20210906134346.19c14246@thinkpad>
In-Reply-To: <YTLP8mYBX37R++9E@bombadil.infradead.org>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
        <20210902174105.2418771-8-mcgrof@kernel.org>
        <YTIscKy+jg5L/TMh@osiris>
        <YTLP8mYBX37R++9E@bombadil.infradead.org>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lKjoO_-t65aECnh67DPT1WhBnwVtT5Mm
X-Proofpoint-GUID: koNu9BnZWKx9Oz09ckXYLCDs_6zcUj8t
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-06_05:2021-09-03,2021-09-06 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 adultscore=0 mlxscore=0 spamscore=0 clxscore=1011 malwarescore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109060073
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, 3 Sep 2021 18:46:26 -0700
Luis Chamberlain <mcgrof@kernel.org> wrote:

> On Fri, Sep 03, 2021 at 04:08:48PM +0200, Heiko Carstens wrote:
> > On Thu, Sep 02, 2021 at 10:41:03AM -0700, Luis Chamberlain wrote:
> > > We never checked for errors on add_disk() as this function
> > > returned void. Now that this is fixed, use the shiny new
> > > error handling.
> > >=20
> > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > ---
> > >  drivers/s390/block/dcssblk.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssbl=
k.c
> > > index 5be3d1c39a78..b0fd5009a12e 100644
> > > --- a/drivers/s390/block/dcssblk.c
> > > +++ b/drivers/s390/block/dcssblk.c
> > > @@ -696,7 +696,9 @@ dcssblk_add_store(struct device *dev, struct devi=
ce_attribute *attr, const char
> > >  	}
> > > =20
> > >  	get_device(&dev_info->dev);
> > > -	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> > > +	rc =3D device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> > > +	if (rc)
> > > +		goto put_dev;
> >=20
> > This looks not correct to me. We seem to have now in case of an error:
> >=20
> > - reference count imbalance (=3D memory leak)
> > - dax cleanup is missing
>=20
> Care to provide an alternative?

See patch below:

=46rom 7053b5f8c0a126c3ef450de3668d9963bd68ceaa Mon Sep 17 00:00:00 2001
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Date: Mon, 6 Sep 2021 13:18:53 +0200
Subject: [PATCH] s390/block/dcssblk: add error handling support for add_dis=
k()

Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
---
 drivers/s390/block/dcssblk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 5be3d1c39a78..0741a9321712 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -696,7 +696,9 @@ dcssblk_add_store(struct device *dev, struct device_att=
ribute *attr, const char
 	}
=20
 	get_device(&dev_info->dev);
-	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
+	rc =3D device_add_disk(&dev_info->dev, dev_info->gd, NULL);
+	if (rc)
+		goto out_dax;
=20
 	switch (dev_info->segment_type) {
 		case SEG_TYPE_SR:
@@ -712,6 +714,10 @@ dcssblk_add_store(struct device *dev, struct device_at=
tribute *attr, const char
 	rc =3D count;
 	goto out;
=20
+out_dax:
+	put_device(&dev_info->dev);
+	kill_dax(dev_info->dax_dev);
+	put_dax(dev_info->dax_dev);
 put_dev:
 	list_del(&dev_info->lh);
 	blk_cleanup_disk(dev_info->gd);
--=20
2.25.1

