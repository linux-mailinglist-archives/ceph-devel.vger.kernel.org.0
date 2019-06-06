Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 883C137FAA
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 23:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728452AbfFFVfp (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 17:35:45 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:50902 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726943AbfFFVfo (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 6 Jun 2019 17:35:44 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id B3C8815F886;
        Thu,  6 Jun 2019 14:35:43 -0700 (PDT)
Date:   Thu, 6 Jun 2019 21:35:41 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     ceph-devel@vger.kernel.org, dev@ceph.io
Subject: Re: octopus planning calls
In-Reply-To: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
Message-ID: <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudeggedgudeihecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopeguvghvsegtvghphhdrihhonecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 6 Jun 2019, Sage Weil wrote:
> Hi everyone,
> 
> We'd like to do some planning calls for octopus.  Each call would be 30-60 
> minutes, and cover (at least) rados, rbd, rgw, and cephfs.  The dashboard 
> team has a face to face meeting next week in Germany so they should be in 
> good shape.  Sebastian, do we need to schedule something on the 
> orchestrator, or just rely on the existing Monday call?
> 
> 1- Does the 1500-1700 UTC time range work well enough for everyone?  We'll 
> record the calls, of course, and send an email summary after.
> 
> 2- What day(s):
> 
>  Tomorrow (Friday Jun 7)
>  Next week (Jun 10-14... may conflict with dashboard f2f)

It seems SUSE's storage team offsite runs through tomorrow, and Monday is 
a holiday in Germany, so let's wait until next week.

How about:

Tue Jun 11:
  1500 UTC  Orchestrator (Sebastian is already planning a call)
  1600 UTC  RADOS
Wed Jun 12:
  1500 UTC  RBD
  1600 UTC  RGW
Thu Jun 13:
  1600 UTC  CephFS

?
sage
