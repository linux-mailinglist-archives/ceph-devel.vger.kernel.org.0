Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAD4E3DA237
	for <lists+ceph-devel@lfdr.de>; Thu, 29 Jul 2021 13:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231674AbhG2Lei (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 29 Jul 2021 07:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231576AbhG2Leh (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 29 Jul 2021 07:34:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1677360F23;
        Thu, 29 Jul 2021 11:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627558474;
        bh=UN46I5PKTeBSf/bTsh0J8eIGMKZ5gfswm+p6t8CbgIo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IltNk4oXWm8oACS0v90M8BqMVI1EjKiPZCr/HESYvrGtatB3OxkoKkaYYY6C3ydoi
         MeqxbWSSiIebOedTNL1J6mbKTNKfSFZ14KFzHom8vlrkFwuUMOrfpq1RObu3PAY9k6
         0EuIHowTvTGSJBrYIekGDql51Fq6lfvwK5rPLsM/61n+WRnlFhd1iSVXPoG6fuPcgO
         HTHnR+LLvA02Sb3VTN5Ic9Ga8BZl1cmDJI9RdMo6W8cRMQnsNf1Q5IppRpCYCzRInU
         YclxSXOOZLWg1DFSMgMWfDlnlXS0SgkclbJJ2PIqDG6pPLgO3Gm0MpK0/YPRsu/eiM
         2QidFBB3zC+zQ==
Message-ID: <10e669ce9cfc2cda22e4762ba62b34fbaecb5102.camel@kernel.org>
Subject: Re: [PATCH] ceph: cancel delayed work instead of flushing on mdsc
 teardown
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Cc:     idryomov@gmail.com
Date:   Thu, 29 Jul 2021 07:34:32 -0400
In-Reply-To: <0c57b1e2-90a6-3580-3ca4-aa95cd1c7126@redhat.com>
References: <20210727201230.178286-1-jlayton@kernel.org>
         <0c57b1e2-90a6-3580-3ca4-aa95cd1c7126@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.3 (3.40.3-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-07-29 at 10:56 +0800, Xiubo Li wrote:
> On 7/28/21 4:12 AM, Jeff Layton wrote:
> > The first thing metric_delayed_work does is check mdsc->stopping,
> > and then return immediately if it's set...which is good since we would
> > have already torn down the metric structures at this point, otherwise.
> > 
> > Worse yet, it's possible that the ceph_metric_destroy call could race
> > with the delayed_work, in which case we could end up a end up accessing
> > destroyed percpu variables.
> > 
> > At this point in the mdsc teardown, the "stopping" flag has already been
> > set, so there's no benefit to flushing the work. Just cancel it instead,
> > and do so before we tear down the metrics structures.
> > 
> > Cc: Xiubo Li <xiubli@redhat.com>
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >   fs/ceph/mds_client.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index c43091a30ba8..d3f2baf3c352 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -4977,9 +4977,9 @@ void ceph_mdsc_destroy(struct ceph_fs_client *fsc)
> >   
> >   	ceph_mdsc_stop(mdsc);
> >   
> > +	cancel_delayed_work_sync(&mdsc->metric.delayed_work);
> >   	ceph_metric_destroy(&mdsc->metric);
> >   
> 
> In the "ceph_metric_destroy()" it will also do 
> "cancel_delayed_work_sync(&mdsc->metric.delayed_work)".
> 
> We can just move the it to the front of the _destory().
> 
> 

Good point! I'll send a v2 after I test it out.

> 
> > -	flush_delayed_work(&mdsc->metric.delayed_work);
> >   	fsc->mdsc = NULL;
> >   	kfree(mdsc);
> >   	dout("mdsc_destroy %p done\n", mdsc);
> 

Thanks,
-- 
Jeff Layton <jlayton@kernel.org>

