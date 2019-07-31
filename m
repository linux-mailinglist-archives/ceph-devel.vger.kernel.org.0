Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 336F17C013
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Jul 2019 13:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbfGaLfT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 31 Jul 2019 07:35:19 -0400
Received: from smtp.digiware.nl ([176.74.240.9]:42218 "EHLO smtp.digiware.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725921AbfGaLfT (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Wed, 31 Jul 2019 07:35:19 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Jul 2019 07:35:18 EDT
Received: from router.digiware.nl (localhost.digiware.nl [127.0.0.1])
        by smtp.digiware.nl (Postfix) with ESMTP id C88D33148F;
        Wed, 31 Jul 2019 13:25:14 +0200 (CEST)
X-Virus-Scanned: amavisd-new at digiware.com
Received: from smtp.digiware.nl ([127.0.0.1])
        by router.digiware.nl (router.digiware.nl [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pAx1MSh5ALwa; Wed, 31 Jul 2019 13:25:13 +0200 (CEST)
Received: from [192.168.10.67] (opteron [192.168.10.67])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp.digiware.nl (Postfix) with ESMTPSA id CAE6C3148E;
        Wed, 31 Jul 2019 13:25:13 +0200 (CEST)
Subject: Re: build status with boost-1.70
To:     Casey Bodley <cbodley@redhat.com>,
        Patrick McLean <chutzpah@gentoo.org>
Cc:     ceph-devel@vger.kernel.org, dev@ceph.io
References: <20190416172438.2de49557@patrickm>
 <901bcbff-1382-8e3e-5fe3-3c9a3d7d3849@redhat.com>
 <20190418184643.3c032bc2@patrickm>
 <4aeeb66c-d2e0-e2f9-63ef-da0de260e0c1@digiware.nl>
 <2855f0d7-3aa6-2ae8-a3f0-5fb013980138@redhat.com>
 <20190424113031.16946a97@patrickm>
 <ea000231-4bfa-6584-9204-9a2b3a5bcd94@digiware.nl>
 <b3b2f734-cc10-cacf-2b97-3e508d5b821b@digiware.nl>
 <d3f63b0c-776d-266d-b7e9-c4a5e4112ba6@redhat.com>
From:   Willem Jan Withagen <wjw@digiware.nl>
Message-ID: <4ad3dfd0-5676-88e8-fd04-9dc30935a8f3@digiware.nl>
Date:   Wed, 31 Jul 2019 13:25:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <d3f63b0c-776d-266d-b7e9-c4a5e4112ba6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On 25-4-2019 22:44, Casey Bodley wrote:
> 
> On 4/25/19 10:50 AM, Willem Jan Withagen wrote:
>> On 25-4-2019 11:56, Willem Jan Withagen wrote:
>>> On 24-4-2019 20:30, Patrick McLean wrote:
>>>> On Wed, 24 Apr 2019 09:35:57 -0400
>>>> Casey Bodley <cbodley@redhat.com> wrote:
>>>>
>>>>> On 4/20/19 6:25 AM, Willem Jan Withagen wrote:
>>>>>> On 19-4-2019 03:46, Patrick McLean wrote:
>>>>>>> On Wed, 17 Apr 2019 09:50:00 -0400
>>>>>>> Casey Bodley <cbodley@redhat.com> wrote:
>>>>>>>> That's good to know, thanks for testing! This one is documented
>>>>>>>> as a breaking change in
>>>>>>>> https://www.boost.org/doc/libs/1_70_0/doc/html/boost_asio/history.html: 
>>>>>>>>
>>>>>>>>
>>>>> I have a branch building against 1.70 in
>>>>> https://github.com/ceph/ceph/pull/27730. I ended up adding '#if
>>>>> BOOST_VERSION < 107000' in a couple places, so we could merge the rgw
>>>>> bits without updating the minimum required version to 1.70. I don't
>>>>> see any immediate benefit to switching now; I just can't guarantee
>>>>> that rgw won't break things in the meantime if we're only testing
>>>>> builds against 1.67. What do you all think?
>>>> This branch builds for me as well, I haven't done any functional
>>>> testing.
>>>>
>>>> Perhaps there could be an option to use either until a full
>>>> switch to 1.70 (or later) is required (I am not sure what kind of cmake
>>>> magic it would take to allow either, but I could take a stab at it if
>>>> it's desired).
>>> I've asked one of the FreeBSD ports maintainers on the plans for boost.
>>>
>>> I'd like to make 2 comments:
>>> 1) The cmake foo is usually the more annoying work, since cmake and 
>>> boots do not really run in sync.
>>> 2) it would be sort of silly not to already prepare for boost going 
>>> to 1.7 and on, if somebody has done the work.
>>>      Question will be how to do the jenkins/QA/teutology testing for 
>>> this, otherwise the fault will only show when testing gets to 1.7
>>
>> I checked with the guys doing boost porting, and 1.70 is on the virge 
>> of arriving in the stable ports tree. Meaning that I'll be needing the 
>> same fixes.... to keep head building.
>>
>> --WjW
>>
> Thanks Willem.
> 
> I updated https://github.com/ceph/ceph/pull/27794 to remove the cmake 
> change that required boost 1.70, so we can revisit that upgrade later. 
> If rgw breaks anything else in the meantime, you guys know where to find 
> me.

I finally got around to do some more work on Ceph, and getting Boost 
1.70 working on FreeBSD was the first thing that was needed as FreeBSD 
13.0-Current only had Boost 1.70.

It was as "simple" as replacing our in-tree FindBoost.cmake with a more 
recent one that understands 1.7....

So atm. HEAD is compiling and testing oke again on FreeBSD:
   http://cephdev.digiware.nl:8180/jenkins/job/ceph-master/3585/console

I guess that it would also allow other platforms to use 1.7 as well.

--WjW

