Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78786305DB
	for <lists+ceph-devel@lfdr.de>; Fri, 31 May 2019 02:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfEaAkv (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 May 2019 20:40:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57806 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726128AbfEaAkv (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 30 May 2019 20:40:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 00A593082B6B
        for <ceph-devel@vger.kernel.org>; Fri, 31 May 2019 00:40:51 +0000 (UTC)
Received: from [10.3.117.97] (ovpn-117-97.phx2.redhat.com [10.3.117.97])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C4C135C324;
        Fri, 31 May 2019 00:40:50 +0000 (UTC)
Subject: Re: CDM next Wednesday: multi-site rbd and cephfs; rados progress
 events
To:     Sage Weil <sweil@redhat.com>, ceph-devel@vger.kernel.org
References: <alpine.DEB.2.11.1905301812380.29593@piezo.novalocal>
From:   Josh Durgin <jdurgin@redhat.com>
Message-ID: <2e2b0a6e-e02e-b5bd-01bf-b23a3dad155d@redhat.com>
Date:   Thu, 30 May 2019 17:40:50 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1905301812380.29593@piezo.novalocal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Fri, 31 May 2019 00:40:51 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 5/30/19 11:17 AM, Sage Weil wrote:
> An initial agenda is up for the Ceph Developer Monthly call next
> Wednesday:
> 
> 	https://tracker.ceph.com/projects/ceph/wiki/CDM_05-JUN-2019
> 
> The call will be at 1630 UTC (12:30pm ET) on Wed June 5th.
> 
>   https://bluejeans.com/908675367
> 
> The current agenda includes:
> 
> - RBD cloud migration (streamling migration of RBD images between
>    clusters)
> - CephFS snap mirroring (disaster recovery solution for cephfs across
>    clusters)
> - RADOS progress module (better events in 'ceph -s' to show progress bars
>    for things like cluster recovery)
> 
> If there are any other pending design discussions for Octopus, feel
> free to add them to the agenda or reply to this thread.

Another topic came up in the rados suite review today: downgrades

Specifically, making it safe to downgrade minor releases, e.g.
from 14.2.1 to 14.2.0. There was a thread on this last year [0],
and there are a few other pieces not mentioned much there, e.g. object
classes, protocol changes, and feature bit rollback.

Josh

[0] https://www.spinics.net/lists/ceph-devel/msg42685.html
