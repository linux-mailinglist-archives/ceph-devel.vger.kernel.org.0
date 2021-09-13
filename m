Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFE27409A02
	for <lists+ceph-devel@lfdr.de>; Mon, 13 Sep 2021 18:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240385AbhIMQxE (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 13 Sep 2021 12:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239727AbhIMQxD (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 13 Sep 2021 12:53:03 -0400
Received: from bombadil.infradead.org (unknown [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D13C061762;
        Mon, 13 Sep 2021 09:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description;
        bh=xmhLMwi2AJDri4EtwlhDWcoIQUb7BB+muDOVcMR8vy0=; b=FtdyiSy0lblJ22JSsFNFEN1L0b
        Kwt5G/wmNlKaP8YypWTFbbQicWo49V0vpXWicsZU+tWZz2vY0q2BcJVNAB77Ex20OVrhlaanqGrsv
        GXmtK2DhdSHr43DUQ2GdkwFPcdZ3UMig7PIfr87L3rql+Xrxw0Pt3NVBdU3FvLJ9uWvOAgNcFURoT
        A5ymKEx6LOVi/hyhmccIOlZuueJDhGIajglMLQIMM1wZAQH53m/c9qN0AMXxRdQIRJ41U/IPBE47Z
        yLIk/KO0G0x9DLGCFPVaqR0PyVvc0OHPpVsKgjwrJUI6L798WFcddLaqIYM25nP2HjngygBfrQQHO
        cQM30FJg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mPpBC-002WDJ-53; Mon, 13 Sep 2021 16:51:38 +0000
Date:   Mon, 13 Sep 2021 09:51:38 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Jan =?iso-8859-1?Q?H=F6ppner?= <hoeppner@linux.ibm.com>
Cc:     axboe@kernel.dk, gregkh@linuxfoundation.org,
        chaitanya.kulkarni@wdc.com, atulgopinathan@gmail.com, hare@suse.de,
        maximlevitsky@gmail.com, oakad@yahoo.com, ulf.hansson@linaro.org,
        colin.king@canonical.com, shubhankarvk@gmail.com,
        baijiaju1990@gmail.com, trix@redhat.com,
        dongsheng.yang@easystack.cn, ceph-devel@vger.kernel.org,
        miquel.raynal@bootlin.com, richard@nod.at, vigneshr@ti.com,
        sth@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com, oberpar@linux.ibm.com, tj@kernel.org,
        linux-s390@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] s390/block/dasd_genhd: add error handling support
 for add_disk()
Message-ID: <YT+Bmvv3yXbuBddi@bombadil.infradead.org>
References: <20210902174105.2418771-1-mcgrof@kernel.org>
 <20210902174105.2418771-7-mcgrof@kernel.org>
 <d6140e40-a472-e732-9893-99e1839b717e@linux.ibm.com>
 <f24da7d5-0b67-fa24-862f-0b27a2ab502c@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f24da7d5-0b67-fa24-862f-0b27a2ab502c@linux.ibm.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Sep 13, 2021 at 02:19:38PM +0200, Jan Höppner wrote:
> On 13/09/2021 10:17, Jan Höppner wrote:
> > On 02/09/2021 19:41, Luis Chamberlain wrote:
> >> We never checked for errors on add_disk() as this function
> >> returned void. Now that this is fixed, use the shiny new
> >> error handling.
> >>
> >> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> >> ---
> >>  drivers/s390/block/dasd_genhd.c | 8 ++++++--
> >>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
> >> index fa966e0db6ca..ba07022283bc 100644
> >> --- a/drivers/s390/block/dasd_genhd.c
> >> +++ b/drivers/s390/block/dasd_genhd.c
> >> @@ -33,7 +33,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
> >>  {
> >>  	struct gendisk *gdp;
> >>  	struct dasd_device *base;
> >> -	int len;
> >> +	int len, rc;
> >>  
> >>  	/* Make sure the minor for this device exists. */
> >>  	base = block->base;
> >> @@ -79,7 +79,11 @@ int dasd_gendisk_alloc(struct dasd_block *block)
> >>  	dasd_add_link_to_gendisk(gdp, base);
> >>  	block->gdp = gdp;
> >>  	set_capacity(block->gdp, 0);
> >> -	device_add_disk(&base->cdev->dev, block->gdp, NULL);
> >> +
> >> +	rc = device_add_disk(&base->cdev->dev, block->gdp, NULL);
> >> +	if (rc)
> >> +		return rc;
> >> +
> > 
> > I think, just like with some of the other changes, there is some
> > cleanup required before returning. I'll prepare a patch and
> > come back to you.
> > 
> 
> It's actually just one call that is required. The patch should
> look like this:
> 
> diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
> index fa966e0db6ca..80673dbfb1f9 100644
> --- a/drivers/s390/block/dasd_genhd.c
> +++ b/drivers/s390/block/dasd_genhd.c
> @@ -33,7 +33,7 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>  {
>         struct gendisk *gdp;
>         struct dasd_device *base;
> -       int len;
> +       int len, rc;
>  
>         /* Make sure the minor for this device exists. */
>         base = block->base;
> @@ -79,7 +79,13 @@ int dasd_gendisk_alloc(struct dasd_block *block)
>         dasd_add_link_to_gendisk(gdp, base);
>         block->gdp = gdp;
>         set_capacity(block->gdp, 0);
> -       device_add_disk(&base->cdev->dev, block->gdp, NULL);
> +
> +       rc = device_add_disk(&base->cdev->dev, block->gdp, NULL);
> +       if (rc) {
> +               dasd_gendisk_free(block);
> +               return rc;
> +       }
> +

Thanks!

Would you like to to fold this fix into my patch and resend eventually?
Or will you send a replacement?

  Luis
