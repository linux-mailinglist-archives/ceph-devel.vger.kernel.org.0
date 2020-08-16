Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE29245A19
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Aug 2020 01:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726165AbgHPXpR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Aug 2020 19:45:17 -0400
Received: from smtprelay0213.hostedemail.com ([216.40.44.213]:47348 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725967AbgHPXpR (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Sun, 16 Aug 2020 19:45:17 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 271DA1801BE2F;
        Sun, 16 Aug 2020 23:45:16 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1567:1593:1594:1711:1714:1730:1747:1777:1792:1978:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3622:3866:3867:3870:3873:4321:4605:5007:7903:9036:9040:10004:10400:10848:11232:11658:11914:12043:12297:12740:12760:12895:13069:13075:13311:13357:13439:14659:14721:21080:21451:21627:30054:30070:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: dress37_0516df027012
X-Filterd-Recvd-Size: 1419
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Sun, 16 Aug 2020 23:45:14 +0000 (UTC)
Message-ID: <b1c625528af035cc74a8f17b903e17e5f15f4a23.camel@perches.com>
Subject: Re: [PATCH 1/2] ceph: Use generic debugging facility
From:   Joe Perches <joe@perches.com>
To:     kernel test robot <lkp@intel.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Cc:     kbuild-all@lists.01.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 16 Aug 2020 16:45:13 -0700
In-Reply-To: <202008170710.BoRBUoeo%lkp@intel.com>
References: <d67377660a317c826a7899e6ffcb5bf686733ddb.1597615399.git.joe@perches.com>
         <202008170710.BoRBUoeo%lkp@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2020-08-17 at 07:03 +0800, kernel test robot wrote:
> I love your patch! Yet something to improve:
[]
> All errors (new ones prefixed by >>):
> 
>    net/ceph/ceph_common.c: In function 'parse_fsid':
> > > net/ceph/ceph_common.c:227:2: error: implicit declaration of function 'dout'; did you mean 'dput'? [-Werror=implicit-function-declaration]
>      227 |  dout("parse_fsid '%s'\n", str);
>          |  ^~~~
>          |  dput

Right, thanks, I didn't update net/.


