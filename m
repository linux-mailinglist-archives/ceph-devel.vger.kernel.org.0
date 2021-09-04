Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31D09400930
	for <lists+ceph-devel@lfdr.de>; Sat,  4 Sep 2021 03:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351188AbhIDBqI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 3 Sep 2021 21:46:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbhIDBqH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 3 Sep 2021 21:46:07 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0678BC061575;
        Fri,  3 Sep 2021 18:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=uPQkDJ1VLKwXdfWErXDT45f84FK2QVIicjx4PbKGh3A=; b=bNJedXy1Kcy9YJ7ZgSP0ssuRoq
        5/vnhn9kTtboYQGK+zUAUyvrHpk6waeUmsrspruaChXP+WKsrE8DgttonEQXfIg1veyHp1Ank7aCO
        j8M8XJtvPJPkje15WOPf+TG52Vp+5uH7EZ3H9Fyv0PdOwdkHkmamKS+RFnzqycY5VVRC5/P8TgZCv
        M+u8QQtMm2CIv3CpDaRvWTqyEzw3SAGXxikHYAkNRZMRk/oCaiD5eJ7lH92fDVV8wiqzOZNMXgzwG
        H03CfV/o4m6WH2Xr5VLXZCpXzIvR6igGZKnHZLZAXajy5snahLiyX8k4YNkG1OXvCqf2F9aEbcLZC
        XbNCXHZA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mMKjm-00DMAS-PL; Sat, 04 Sep 2021 01:44:54 +0000
Date:   Fri, 3 Sep 2021 18:44:54 -0700
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] s390/block/xpram: add error handling support for
 add_disk()
Message-ID: <YTLPlmWMhL4+03UH@bombadil.infradead.org>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-10-mcgrof@kernel.org>
 <YTIr1w/qPvgioUfL@osiris>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTIr1w/qPvgioUfL@osiris>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, Sep 03, 2021 at 04:06:15PM +0200, Heiko Carstens wrote:
> On Thu, Sep 02, 2021 at 10:41:05AM -0700, Luis Chamberlain wrote:
> > We never checked for errors on add_disk() as this function
> > returned void. Now that this is fixed, use the shiny new
> > error handling.
> > 
> > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > ---
> >  drivers/s390/block/xpram.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
> > index ce98fab4d43c..ed3904b6a9c8 100644
> > --- a/drivers/s390/block/xpram.c
> > +++ b/drivers/s390/block/xpram.c
> > @@ -371,7 +371,9 @@ static int __init xpram_setup_blkdev(void)
> >  		disk->private_data = &xpram_devices[i];
> >  		sprintf(disk->disk_name, "slram%d", i);
> >  		set_capacity(disk, xpram_sizes[i] << 1);
> > -		add_disk(disk);
> > +		rc = add_disk(disk);
> > +		if (rc)
> > +			goto out;
> 
> Hmm, this is a more or less dead device driver, and I'm wondering if
> we shouldn't remove it instead. But anyway, your patch is not correct:
> 
> - del_gendisk for all registered disks has to be called
> - unregister_blkdev(XPRAM_MAJOR, XPRAM_NAME) is missing as well
> 
> That would be more or or less xpram_exit with parameter.
> 
> You can send a new patch or I can provide a proper one, whatever you
> prefer.

You are more familiar with the code so it would be great if you can send
a patch replacement and I will drop mine. I have quite a bit of other
conversions to deal with.

 Luis
