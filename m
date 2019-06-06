Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8985438009
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 23:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfFFVzY (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 6 Jun 2019 17:55:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbfFFVzY (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 17:55:24 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 46B6930593D8;
        Thu,  6 Jun 2019 21:55:24 +0000 (UTC)
Received: from [10.3.117.56] (ovpn-117-56.phx2.redhat.com [10.3.117.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id EDD537C45F;
        Thu,  6 Jun 2019 21:55:23 +0000 (UTC)
Subject: Re: octopus planning calls
To:     Sage Weil <sage@newdream.net>, ceph-devel@vger.kernel.org,
        dev@ceph.io
References: <alpine.DEB.2.11.1906061434200.13706@piezo.novalocal>
 <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
From:   Josh Durgin <jdurgin@redhat.com>
Message-ID: <ea7feb51-7c50-9c44-a05e-b529cab797a8@redhat.com>
Date:   Thu, 6 Jun 2019 14:55:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1906062131180.12100@piezo.novalocal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 06 Jun 2019 21:55:24 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 6/6/19 2:35 PM, Sage Weil wrote:
> On Thu, 6 Jun 2019, Sage Weil wrote:
>> Hi everyone,
>>
>> We'd like to do some planning calls for octopus.  Each call would be 30-60
>> minutes, and cover (at least) rados, rbd, rgw, and cephfs.  The dashboard
>> team has a face to face meeting next week in Germany so they should be in
>> good shape.  Sebastian, do we need to schedule something on the
>> orchestrator, or just rely on the existing Monday call?
>>
>> 1- Does the 1500-1700 UTC time range work well enough for everyone?  We'll
>> record the calls, of course, and send an email summary after.
>>
>> 2- What day(s):
>>
>>   Tomorrow (Friday Jun 7)
>>   Next week (Jun 10-14... may conflict with dashboard f2f)
> 
> It seems SUSE's storage team offsite runs through tomorrow, and Monday is
> a holiday in Germany, so let's wait until next week.
> 
> How about:
> 
> Tue Jun 11:
>    1500 UTC  Orchestrator (Sebastian is already planning a call)
>    1600 UTC  RADOS

Could we do rados later in the week, Wed, Thurs or Fri 1600 UTC?
