Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1544C10EAC2
	for <lists+ceph-devel@lfdr.de>; Mon,  2 Dec 2019 14:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbfLBNYK (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 2 Dec 2019 08:24:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:42798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727381AbfLBNYK (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 08:24:10 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E51F206E4;
        Mon,  2 Dec 2019 13:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575293049;
        bh=tDzr1kOLrgCFoQHFTim2nvRT8MlrL77lQduwnPFB62M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=wpWHySpQmOGOe68Uywe1h16lNR3dyT50jAYAlabN0sXJ2eBQURaCyRbg1gcxsPeSL
         sLoJP+Rt09WEo7qvCs9Zbq/sat+2zMO07WYGYHoyBY0b8Q6/DQB8ahdpCeCF0J17hm
         Rk3xY/YEX7n/TmdFhZSpbH0lSey0Bc6+yYXjueMI=
Message-ID: <69bc9a4511ab74028afd5036e22bc06351061be6.camel@kernel.org>
Subject: Re: [RFC PATCH] ceph: fix cap revoke race
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, "Yan, Zheng" <zyan@redhat.com>
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Mon, 02 Dec 2019 08:24:08 -0500
In-Reply-To: <94793fb0-4527-7102-3529-074856c00db5@redhat.com>
References: <20191127104549.33305-1-xiubli@redhat.com>
         <26da58b0-9e6a-70a8-641e-65b2c6ee075a@redhat.com>
         <94793fb0-4527-7102-3529-074856c00db5@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-11-28 at 15:53 +0800, Xiubo Li wrote:
> On 2019/11/28 10:25, Yan, Zheng wrote:
> > On 11/27/19 6:45 PM, xiubli@redhat.com wrote:
> > > From: Xiubo Li <xiubli@redhat.com>
> > > 
> > > The cap->implemented is one subset of the cap->issued, the logic
> > > here want to exclude the revoking caps, but the following code
> > > will be (~cap->implemented | cap->issued) == 0xFFFF, so it will
> > > make no sense when we doing the "have &= 0xFFFF".
> > > 
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > ---
> > >   fs/ceph/caps.c | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> > > index c62e88da4fee..a9335402c2a5 100644
> > > --- a/fs/ceph/caps.c
> > > +++ b/fs/ceph/caps.c
> > > @@ -812,7 +812,7 @@ int __ceph_caps_issued(struct ceph_inode_info 
> > > *ci, int *implemented)
> > >        */
> > >       if (ci->i_auth_cap) {
> > >           cap = ci->i_auth_cap;
> > > -        have &= ~cap->implemented | cap->issued;
> > > +        have &= ~(cap->implemented & ~cap->issued);
> > 
> > The end result is the same.
> > 
> > See https://en.wikipedia.org/wiki/De_Morgan%27s_laws
> > 
> Yeah, right, it is.
> 
> BRs
> 

Dropping this patch.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

