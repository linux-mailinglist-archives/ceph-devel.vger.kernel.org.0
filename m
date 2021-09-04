Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A5E400937
	for <lists+ceph-devel@lfdr.de>; Sat,  4 Sep 2021 03:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351200AbhIDBre (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Sep 2021 21:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhIDBre (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Sep 2021 21:47:34 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F1F6C061575;
        Fri,  3 Sep 2021 18:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=emXHCsSESDsYXgDCyO6guaMlmVA/Vr3ZoS3mPS968XI=; b=c5XTnTtIW70QIk/iVIvzb87JqI
        tcT6qmY0efhEByu3yHG3p3VkkNGOyvSC3Qzi3Rn531DUP7oflNexg74DFSPZhSkjAQgPmwewphC/6
        15RYnx5OSbnGFML3VcF08GO6poVHJBYxEXOeQKreYYZ9NeTiNb0KI81iI/KO1cvzX8bvKgRKPlNKI
        Mmmxhy4Zk6EV2DJEWS7sgmKTDPA5PFD17EJj3P3ozicrR5I23lkS3YoDhGa7fDEYz73HOICanJRmR
        OupJiQBNOPTq+2llAsgwuYjfz/JGKwLDBGSA+iLKuFjUFPnkEexHGj/Rb7QY1jlzJDg/fXmzl6DtQ
        AVXG3Iag==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mMKlG-00DMId-9g; Sat, 04 Sep 2021 01:46:26 +0000
Date:   Fri, 3 Sep 2021 18:46:26 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        chaitanya.kulkarni@wdc.com, atulgopinathan@gmail.com, hare@suse.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        colin.king@canonical.com, shubhankarvk@gmail.com,
        baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hoeppner@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Subject: Re: [PATCH 7/9] s390/block/dcssblk: add error handling support for
 add_disk()
Message-ID: <YTLP8mYBX37R++9E@bombadil.infradead.org>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-8-mcgrof@kernel.org>
 <YTIscKy+jg5L/TMh@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTIscKy+jg5L/TMh@osiris>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 03, 2021 at 04:08:48PM +0200, Heiko Carstens wrote:
> On Thu, Sep 02, 2021 at 10:41:03AM -0700, Luis Chamberlain wrote:
> > We never checked for errors on add_disk() as this function
> > returned void. Now that this is fixed, use the shiny new
> > error handling.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  drivers/s390/block/dcssblk.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
> > index 5be3d1c39a78..b0fd5009a12e 100644
> > --- a/drivers/s390/block/dcssblk.c
> > +++ b/drivers/s390/block/dcssblk.c
> > @@ -696,7 +696,9 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
> >  	}
> >  
> >  	get_device(&dev_info->dev);
> > -	device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> > +	rc = device_add_disk(&dev_info->dev, dev_info->gd, NULL);
> > +	if (rc)
> > +		goto put_dev;
> 
> This looks not correct to me. We seem to have now in case of an error:
> 
> - reference count imbalance (= memory leak)
> - dax cleanup is missing

Care to provide an alternative?

  Luis
