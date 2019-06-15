Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81D8246DF4
	for <lists+ceph-devel@lfdr.de>; Sat, 15 Jun 2019 05:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFODG4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 14 Jun 2019 23:06:56 -0400
Received: from smtprelay0071.hostedemail.com ([216.40.44.71]:59127 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725812AbfFODGz (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Fri, 14 Jun 2019 23:06:55 -0400
X-Greylist: delayed 508 seconds by postgrey-1.27 at vger.kernel.org; Fri, 14 Jun 2019 23:06:55 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 9036218019B31
        for <ceph-devel@vger.kernel.org>; Sat, 15 Jun 2019 02:58:28 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay02.hostedemail.com (Postfix) with ESMTP id C0F2540EE;
        Sat, 15 Jun 2019 02:58:26 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3874:4250:4321:5007:6119:7903:8660:10004:10400:10848:11232:11658:11914:12296:12740:12760:12895:13069:13148:13161:13229:13230:13311:13357:13439:14096:14097:14181:14659:14721:21080:21433:21627:30054:30060:30090:30091,0,RBL:23.242.70.174:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: waves33_4975be92db727
X-Filterd-Recvd-Size: 2217
Received: from XPS-9350 (cpe-23-242-70-174.socal.res.rr.com [23.242.70.174])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Sat, 15 Jun 2019 02:58:24 +0000 (UTC)
Message-ID: <75c8f066c3aa2e20db2e1554a4d28c20b2952724.camel@perches.com>
Subject: Re: [PATCH 1/3] lib/vsprintf: add snprintf_noterm
From:   Joe Perches <joe@perches.com>
To:     "Yan, Zheng" <ukernel@gmail.com>, Jeff Layton <jlayton@kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ilya Dryomov <idryomov@gmail.com>, Zheng Yan <zyan@redhat.com>,
        Sage Weil <sage@redhat.com>, agruenba@redhat.com
Date:   Fri, 14 Jun 2019 19:58:23 -0700
In-Reply-To: <CAAM7YAnZ=NtsOuR0Pm82fWCSUdFLkJ7NLNk+fNK9+T4viW=_1Q@mail.gmail.com>
References: <20190614134625.6870-1-jlayton@kernel.org>
         <20190614134625.6870-2-jlayton@kernel.org>
         <CAAM7YAnZ=NtsOuR0Pm82fWCSUdFLkJ7NLNk+fNK9+T4viW=_1Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, 2019-06-15 at 10:41 +0800, Yan, Zheng wrote:
> On Fri, Jun 14, 2019 at 9:48 PM Jeff Layton <jlayton@kernel.org> wrote:
> > The getxattr interface returns a length after filling out the value
> > buffer, and the convention with xattrs is to not NULL terminate string
> > data.
> > 
> > CephFS implements some virtual xattrs by using snprintf to fill the
> > buffer, but that always NULL terminates the string. If userland sends
> > down a buffer that is just the right length to hold the text without
> > termination then we end up truncating the value.
> > 
> > Factor the formatting piece of vsnprintf into a separate helper
> > function, and have vsnprintf call that and then do the NULL termination
> > afterward. Then add a snprintf_noterm function that calls the new helper
> > to populate the string but skips the termination.

Is this function really necessary enough to add
the additional stack use to the generic case?

Why not add have this function call vsnprintf
and then terminate the string separately?


