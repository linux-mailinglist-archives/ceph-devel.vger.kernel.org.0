Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC181625E2
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Feb 2020 13:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgBRMBy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 18 Feb 2020 07:01:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgBRMBy (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 18 Feb 2020 07:01:54 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F0952173E;
        Tue, 18 Feb 2020 12:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582027313;
        bh=4PR946olGe9T3Nv0tMnvSD21c3WAwBj5xVSXU27rL1E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FuEth3R9Gwvqo4srq7FggTMF/d1zku6nARd9Y8+hbMin9yR9kIV+43VXE0Rk+tFhU
         3Z25sfsImtVuM+ofCic66SXdEJ0ffHQXVM+fhZ481arGlaP3ruHp8eJ99TXyDOCcz5
         kW/RWnfuKkC5uNfn3vuaZ7C3388+hqLDrjb+sMug=
Message-ID: <4a4cfe2a5fc1de6f73fa3f557921c1ad5802add6.camel@kernel.org>
Subject: Re: [PATCH] ceph: add halt mount option support
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, idryomov@gmail.com
Cc:     sage@redhat.com, zyan@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Tue, 18 Feb 2020 07:01:52 -0500
In-Reply-To: <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com>
References: <20200216064945.61726-1-xiubli@redhat.com>
         <78ff80dd12d497be7a6606a60973f7e2d864e910.camel@kernel.org>
         <36e1f3a9-1688-9eb0-27d7-351a12bca85a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2020-02-18 at 15:19 +0800, Xiubo Li wrote:
> On 2020/2/17 21:04, Jeff Layton wrote:
> > On Sun, 2020-02-16 at 01:49 -0500, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > This will simulate pulling the power cable situation, which will
> > > do:
> > > 
> > > - abort all the inflight osd/mds requests and fail them with -EIO.
> > > - reject any new coming osd/mds requests with -EIO.
> > > - close all the mds connections directly without doing any clean up
> > >    and disable mds sessions recovery routine.
> > > - close all the osd connections directly without doing any clean up.
> > > - set the msgr as stopped.
> > > 
> > > URL: https://tracker.ceph.com/issues/44044
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > There is no explanation of how to actually _use_ this feature? I assume
> > you have to remount the fs with "-o remount,halt" ? Is it possible to
> > reenable the mount as well?  If not, why keep the mount around? Maybe we
> > should consider wiring this in to a new umount2() flag instead?
> > 
> > This needs much better documentation.
> > 
> > In the past, I've generally done this using iptables. Granted that that
> > is difficult with a clustered fs like ceph (given that you potentially
> > have to set rules for a lot of addresses), but I wonder whether a scheme
> > like that might be more viable in the long run.
> > 
> How about fulfilling the DROP iptable rules in libceph ? Could you 
> foresee any problem ? This seems the one approach could simulate pulling 
> the power cable.
> 

Yeah, I've mostly done this using DROP rules when I needed to test things.
But, I think I was probably just guilty of speculating out loud here.

I think doing this by just closing down the sockets is probably fine. I
wouldn't pursue anything relating to to iptables here, unless we have
some larger reason to go that route.

-- 
Jeff Layton <jlayton@kernel.org>

