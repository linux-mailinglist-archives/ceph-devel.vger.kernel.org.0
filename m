Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 100E617A737
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Mar 2020 15:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgCEORb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Mar 2020 09:17:31 -0500
Received: from tragedy.dreamhost.com ([66.33.205.236]:57159 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgCEORb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Mar 2020 09:17:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 846E115F883;
        Thu,  5 Mar 2020 06:17:30 -0800 (PST)
Date:   Thu, 5 Mar 2020 14:17:28 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     "Chen, Haochuan Z" <haochuan.z.chen@intel.com>
cc:     "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
        "dev@ceph.io" <dev@ceph.io>
Subject: Re: question about setuser-match-path
In-Reply-To: <56829C2A36C2E542B0CCB9854828E4D8562BB8A8@CDSMSX102.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.21.2003051414310.29770@piezo.novalocal>
References: <56829C2A36C2E542B0CCB9854828E4D8562BB8A8@CDSMSX102.ccr.corp.intel.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedugedruddutddgieehucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffujgfkfhgfgggtsehttdertddtredvnecuhfhrohhmpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqnecukfhppeduvdejrddtrddtrddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtohepuggvvhestggvphhhrdhioh
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 5 Mar 2020, Chen, Haochuan Z wrote:
> Hi
> 
> I wonder what's this arg "--setuser-match-path=", and with this arg set, 
> what will do for ceph daemon.

This is a workaround to enable easier upgrades from ceph version when 
the ceph-osd daemon ran as root.  When we first started running as user 
'ceph', it was necessary to either (1) chown -R ceph:ceph all of the 
files on the HDD/SSD (filestore!), which could take hours, or (2) somehow 
conditionally make ceph-osd continue to run as root instead of dropping to 
user ceph.  This flag allows that by checking whether the path is owned by 
the intended uid/gid to setuid too.. and if it doesn't match, we 
skip the calls to setuid (and continue running as root).

This all happened back in the giant or hammer release, I think.  But we 
need to keep this around since there are still OSDs with filestore that 
were created back then that are owned by root.

sage
