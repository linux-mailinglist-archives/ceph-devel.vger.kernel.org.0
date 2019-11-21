Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E031105894
	for <lists+ceph-devel@lfdr.de>; Thu, 21 Nov 2019 18:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbfKUR3J (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 21 Nov 2019 12:29:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726279AbfKUR3J (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:29:09 -0500
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A347F2067D;
        Thu, 21 Nov 2019 17:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574357348;
        bh=BEMj9YDaYLcAsUsCAOxlyyaflpOu5xBIU3gfX/FCsXA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KvQlkJ6zLGNQvOLXlAHjKgcTk6v2gdQajUvKA69iRJZ635YUkqTngMd2ILitLQgB4
         tXvCVooZtFdqK0ruX9KbftmkuQxIQzGXXkpyfQbv5YvpTbuLpaDz9ate4cjWn2hXZm
         b8qnI//XSBjuC/HBu+SC04dpy8MlzohlilQZTs54=
Message-ID: <211c20e8367d7bc309fa0e9b902eba0a508665ae.camel@kernel.org>
Subject: Re: [PATCH 0/3] mdsmap: fix mds choosing
From:   Jeff Layton <jlayton@kernel.org>
To:     Xiubo Li <xiubli@redhat.com>, "Yan, Zheng" <zyan@redhat.com>
Cc:     sage@redhat.com, idryomov@gmail.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
Date:   Thu, 21 Nov 2019 12:28:59 -0500
In-Reply-To: <f3a54240-b18c-064b-cd9a-1ec64202798a@redhat.com>
References: <20191120082902.38666-1-xiubli@redhat.com>
         <23c18302b3b9e730e304fde39d07477ef29faf1c.camel@kernel.org>
         <f43d582a-5ca5-2f69-7d0e-792665367e83@redhat.com>
         <f3a54240-b18c-064b-cd9a-1ec64202798a@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 (3.34.1-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2019-11-21 at 19:28 +0800, Xiubo Li wrote:
> On 2019/11/21 10:42, Yan, Zheng wrote:
> > On 11/20/19 9:50 PM, Jeff Layton wrote:
> > > On Wed, 2019-11-20 at 03:28 -0500, xiubli@redhat.com wrote:
> > > > From: Xiubo Li <xiubli@redhat.com>
> > > > 
> > > > Xiubo Li (3):
> > > >    mdsmap: add more debug info when decoding
> > > >    mdsmap: fix mdsmap cluster available check based on laggy number
> > > >    mdsmap: only choose one MDS who is in up:active state without laggy
> > > > 
> > > >   fs/ceph/mds_client.c |  6 ++++--
> > > >   fs/ceph/mdsmap.c     | 27 ++++++++++++++++++---------
> > > >   2 files changed, 22 insertions(+), 11 deletions(-)
> > > > 
> > > 
> > > These all look good to me. I'll plan to merge them for v5.5, unless
> > > anyone else sees issues with them.
> > > 
> > > Thanks!
> > > 
> > 
> > Main problem of this series is that we need to distinguish between mds 
> > crash and transient mds laggy.
> 
> How about let's try to check and get an up:active & !laggy mds first, if 
> we couldn't find one then fall back to one that is up:active & laggy ?
> 
> For the auth mds case, we will ignore the laggy stuff.
> 

Ok. I've dropped this series for now with the expectation that you'll
re-post when you have something ready.

Cheers,
-- 
Jeff Layton <jlayton@kernel.org>

