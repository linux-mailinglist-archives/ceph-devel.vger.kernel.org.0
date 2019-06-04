Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52EA334935
	for <lists+ceph-devel@lfdr.de>; Tue,  4 Jun 2019 15:43:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfFDNmr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 4 Jun 2019 09:42:47 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:42778 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727129AbfFDNmq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 4 Jun 2019 09:42:46 -0400
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id C88A615F88C;
        Tue,  4 Jun 2019 06:42:43 -0700 (PDT)
Date:   Tue, 4 Jun 2019 13:42:41 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Ugis <ugis22@gmail.com>
cc:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: rbd blocking, no health warning
In-Reply-To: <CAE63xUM=y_EJjtdzJud_=cL4-iPX6CBBUMGbAQ5q+yZ9RCr8iA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1906041336210.12100@piezo.novalocal>
References: <CAE63xUM=y_EJjtdzJud_=cL4-iPX6CBBUMGbAQ5q+yZ9RCr8iA@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudefledgieekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecukfhppeduvdejrddtrddtrddunecurfgrrhgrmhepmhhouggvpehsmhhtphdphhgvlhhopehlohgtrghlhhhoshhtpdhinhgvthepuddvjedrtddrtddruddprhgvthhurhhnqdhprghthhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqedpmhgrihhlfhhrohhmpehsrghgvgesnhgvfigurhgvrghmrdhnvghtpdhnrhgtphhtthhopegtvghphhdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 4 Jun 2019, Ugis wrote:
> Hi,
> 
> ceph version 14.2.1 (d555a9489eb35f84f2e1ef49b77e19da9d113972) nautilus (stable)
> Yesterday we had massive ceph reballancing due to stopped osd daemons
> on one host, but issue was fixed and data migrated back till HEALTH_OK
> state.
> 
> Today we had strange rbd blocking issue. Windows server used rbd over
> tgt iscsi but I/O in rbd disks suddenly stopped - shares did not
> respond, could not delete file etc.
> Tgt iscsi daemon side logs showed following(after googling I conclude
> these mean ceph backend timeout on iscsi commands):
> # journalctl -f -u tgt.service
> ...
> Jun 04 12:29:16 cgw1 tgtd[12506]: tgtd: abort_cmd(1324) found 7a5f0400 6
> Jun 04 12:29:16 cgw1 tgtd[12506]: tgtd: abort_cmd(1324) found 785f0400 6
> Jun 04 12:29:16 cgw1 tgtd[12506]: tgtd: abort_cmd(1324) found 765f0400 6
> Jun 04 12:29:16 cgw1 tgtd[12506]: tgtd: abort_cmd(1324) found 755f0400 6
> Jun 04 12:29:35 cgw1 tgtd[12506]: tgtd: conn_close(92) already closed
> 0x1b67040 9
> 
> At this point ceph health detail showed nothing wrong(to be clear,
> there was and still is hanging one active+recovering+repair pg, but it
> was not related to pool of windows server and below mentioned osd.35
> not involved - so should not have any effect).
> 
> I started to dig monitor logs and noticed following:
> 
> ceph-mon
> ...
> 2019-06-04 06:25:11.194 7f6dc9034700 -1 mon.ceph1@0(leader) e23
> get_health_metrics reporting 1 slow ops, oldest is osd_failure(failed
> timeout osd.35 v1:10.100.3.7:6801/2979 for 633956sec e372024 v372024)

This is definitely a bug.  Did the ceph health indicate there was a slow 
mon request?

Note that 633956sec is ~1 week... so that also looks fishy.  Is it 
possible the clocks shifted on your OSD nodes?  

> As "failed timeout osd.35" seemed suspicious I restarted that daemon
> and I/O on windows server went live again.
> 
> ceph-osd before restart : tail -f /var/log/ceph/ceph-osd.35.log
> 
> 2019-06-04 12:42:08.036 7fab336e8700 -1 osd.35 372024
> get_health_metrics reporting 27 slow ops, oldest is
> osd_op(client.132208006.0:224153909 54.53
> 54:ca20732d:::rbd_data.5fc5542ae8944a.000000000001d0dd:head
> [set-alloc-hint object_size 4194304 write_size 4194304,write
> 3538944~4096] snapc 0=[] ondisk+write+known_if_redirected e372024)
> 2019-06-04 12:42:09.036 7fab336e8700 -1 osd.35 372024
> get_health_metrics reporting 27 slow ops, oldest is
> osd_op(client.132208006.0:224153909 54.53
> 54:ca20732d:::rbd_data.5fc5542ae8944a.000000000001d0dd:head
> [set-alloc-hint object_size 4194304 write_size 4194304,write
> 3538944~4096] snapc 0=[] ondisk+write+known_if_redirected e372024)
> 2019-06-04 12:42:10.040 7fab336e8700 -1 osd.35 372024
> get_health_metrics reporting 27 slow ops, oldest is
> osd_op(client.132208006.0:224153909 54.53
> 54:ca20732d:::rbd_data.5fc5542ae8944a.000000000001d0dd:head
> [set-alloc-hint object_size 4194304 write_size 4194304,write
> 3538944~4096] snapc 0=[] ondisk+write+known_if_redirected e372024)
> 
> Here I noticed pg "54.53" - that is related to blocking rbd.
> 
> So in short: rbd I/O resumed only after osd.35 restart.
> 
> Question: why ceph health detail did not inform about blocking osd
> issue? Is it a bug?

That also sounds like a bug.

What does your 'ceph -s' say?  Is it possible your mgr is down or 
something?  (The OSD health alerts are fed via the mgr to the mon.)

sage
