Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 657D7415A5C
	for <lists+ceph-devel@lfdr.de>; Thu, 23 Sep 2021 10:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbhIWIyV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 Sep 2021 04:54:21 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33874 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240018AbhIWIyV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 23 Sep 2021 04:54:21 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18N7VEMw021941;
        Thu, 23 Sep 2021 04:52:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=vi//wIVyT+h5+C9jizJGkEb5o7LV4fbjChl0kUpetww=;
 b=ZahMwh30SuExkEvWaCr4uDmzth0/Ynn/aa+vNfgPGvQyFRMZP7bCkaBLi1sy5ObAJiuL
 LR6QwWhhMYvwuzAcrehriLgx+VJn6JTrHTJd+a/CPsF5+o8flAz5raWqxdCIbQGvkjs+
 3VE4VSyxbCWJZQpU/zj9VL9diXQQm4icfrC7Izb/Pk4ZHDc85pys8hJ0buAizg9eJfOB
 p5GSaOWyBePyx3Cioe1YtKtLM3g0dXpsR4wC9TM7MxnEnfO+VEvwtSjIpl0d+xHKCzGR
 PauF1TgmwASkD1w2mvn0DmP3UD5b1kbRtDtjSsOG2ghcvqqk0cYcnigj89TJnknQm9s7 4g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b8n8q1skh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 04:52:21 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 18N87m8F003634;
        Thu, 23 Sep 2021 04:52:19 -0400
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3b8n8q1sjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 04:52:19 -0400
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 18N8hx4k020988;
        Thu, 23 Sep 2021 08:52:16 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06fra.de.ibm.com with ESMTP id 3b7q6pq4ab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Sep 2021 08:52:16 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 18N8lKmU54133162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Sep 2021 08:47:20 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 824174C1C0;
        Thu, 23 Sep 2021 08:52:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 71F604C182;
        Thu, 23 Sep 2021 08:52:10 +0000 (GMT)
Received: from osiris (unknown [9.145.165.148])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Thu, 23 Sep 2021 08:52:10 +0000 (GMT)
Date:   Thu, 23 Sep 2021 10:52:08 +0200
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Gerald Schaefer <gerald.schaefer@linux.ibm.com>, axboe@kernel.dk,
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
Message-ID: <YUxAOKY7dXZAABhI@osiris>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-8-mcgrof@kernel.org>
 <YTIscKy+jg5L/TMh@osiris>
 <YTLP8mYBX37R++9E@bombadil.infradead.org>
 <20210906134346.19c14246@thinkpad>
 <YT+B+vCUcpZEq8hM@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YT+B+vCUcpZEq8hM@bombadil.infradead.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2XeQEdid_UYFD9jsrBRsyb10jcGxIyKO
X-Proofpoint-GUID: oI5-SgomwrvMO_toFwGrIdfrCQ0BSo8E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.391,FMLib:17.0.607.475
 definitions=2021-09-23_02,2021-09-22_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 spamscore=0 malwarescore=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 adultscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109230052
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 13, 2021 at 09:53:14AM -0700, Luis Chamberlain wrote:
> On Mon, Sep 06, 2021 at 01:43:46PM +0200, Gerald Schaefer wrote:
> > On Fri, 3 Sep 2021 18:46:26 -0700
> > Luis Chamberlain <mcgrof@kernel.org> wrote:
> > 
> > > On Fri, Sep 03, 2021 at 04:08:48PM +0200, Heiko Carstens wrote:
> > > > On Thu, Sep 02, 2021 at 10:41:03AM -0700, Luis Chamberlain wrote:
> > > > > We never checked for errors on add_disk() as this function
> > > > > returned void. Now that this is fixed, use the shiny new
> > > > > error handling.
> > > > > 
> > > > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > > > ---
> > > > >  drivers/s390/block/dcssblk.c | 4 +++-
> > > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > > > 
> > > > > diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> > > > > index 5be3d1c39a78..b0fd5009a12e 100644
> > > > > --- a/drivers/s390/block/dcssblk.c
> > > > > +++ b/drivers/s390/block/dcssblk.c
> > > > > @@ -696,7 +696,9 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
> > > > >  	}
> > > > >  
> > > > >  	get_device(&dev_info->dev);
> > > > > -	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> > > > > +	rc = device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> > > > > +	if (rc)
> > > > > +		goto put_dev;
> > > > 
> > > > This looks not correct to me. We seem to have now in case of an error:
> > > > 
> > > > - reference count imbalance (= memory leak)
> > > > - dax cleanup is missing
> > > 
> > > Care to provide an alternative?
> > 
> > See patch below:
> 
> Thanks! Will you queue this up on your end or do would you
> prefer for me to roll this into my tree and eventually resend
> with the rest?

Please add the patch to your tree.
