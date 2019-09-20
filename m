Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BBB35B939E
	for <lists+ceph-devel@lfdr.de>; Fri, 20 Sep 2019 17:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389994AbfITPA5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 Sep 2019 11:00:57 -0400
Received: from tragedy.dreamhost.com ([66.33.205.236]:33961 "EHLO
        tragedy.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388416AbfITPA5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 Sep 2019 11:00:57 -0400
X-Greylist: delayed 347 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Sep 2019 11:00:56 EDT
Received: from localhost (localhost [127.0.0.1])
        by tragedy.dreamhost.com (Postfix) with ESMTPS id 6C76515F8C6;
        Fri, 20 Sep 2019 07:55:08 -0700 (PDT)
Date:   Fri, 20 Sep 2019 14:55:06 +0000 (UTC)
From:   Sage Weil <sage@newdream.net>
X-X-Sender: sage@piezo.novalocal
To:     Alfredo Deza <adeza@redhat.com>
cc:     ceph-devel <ceph-devel@vger.kernel.org>
Subject: Re: Set/Unset OSD 'Allows Journal'
In-Reply-To: <CAC-Np1xa5riFgb_tZG3vFn-dcuKtyV+BSCBZV6uu8+6JRrnrWQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1909201453051.5147@piezo.novalocal>
References: <CAC-Np1xa5riFgb_tZG3vFn-dcuKtyV+BSCBZV6uu8+6JRrnrWQ@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-VR-STATUS: OK
X-VR-SCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedufedrvddvgdekudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucggtfgfnhhsuhgsshgtrhhisggvpdfftffgtefojffquffvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeffhffvufgjkfhffgggtgesthdtredttdervdenucfhrhhomhepufgrghgvucghvghilhcuoehsrghgvgesnhgvfigurhgvrghmrdhnvghtqeenucfkphepuddvjedrtddrtddrudenucfrrghrrghmpehmohguvgepshhmthhppdhhvghloheplhhotggrlhhhohhsthdpihhnvghtpeduvdejrddtrddtrddupdhrvghtuhhrnhdqphgrthhhpefurghgvgcuhggvihhluceoshgrghgvsehnvgifughrvggrmhdrnhgvtheqpdhmrghilhhfrhhomhepshgrghgvsehnvgifughrvggrmhdrnhgvthdpnhhrtghpthhtoheptggvphhhqdguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptd
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 19 Sep 2019, Alfredo Deza wrote:
> After deploying Ceph with ceph-deploy on Bionic, the latest luminous
> (12.2.12) has ceph-disk creating a file for a journal - something that
> is very surprising as I have never seen that functionality in
> ceph-disk, without specifying any flags that might indicate a file is
> needed.
> 
> Using the same approach with ceph-ansible, the OSD would be created
> with a partition (again, via ceph-disk). Same arguments and all,
> similar to:
> 
> ceph-disk -v prepare --cluster=ceph --filestore --dmcrypt /dev/sdX
> 
> After going through all the ceph-disk output, this line got different
> results from the ceph-deploy cluster than the ceph-ansible one:
> 
> /usr/bin/ceph-osd --check-allows-journal -i 0 --log-file
> /var/log/ceph/$cluster-osd-check.log --cluster ceph --setuser ceph
> --setgroup ceph

This will always be true for filestore and always false for bluestore.  
Perhaps this is a subtle change due to the default for osd_objectstore 
having changed between versions?  I think the "fix" is probably to pass 
'--osd-objecstore bluestore' or '--osd-objecstore filestore' to this 
command depending on which type of store was getting created?

sage


 > 
> The ceph-deploy cluster returns a 'no' the ceph-ansible one returns a 'yes'.
> 
> The documentation doesn't seem to explain where or how to set/unset
> this. The references to the flag itself are minimal, just mentioning
> that the '--allows-journal' flag is to check if a journal is allowed
> or not.
> 
> How does one tell a cluster that a journal is allowed (or not)?
> 
> I am happy to go and expand on the documentation to explain this a bit
> even if it is for Luminous only since ceph-volume doesn't check this.
> 
> 
