Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2F13377D
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 20:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbfFCSG0 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 3 Jun 2019 14:06:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49316 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfFCSG0 (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 3 Jun 2019 14:06:26 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 398BEC0524FB;
        Mon,  3 Jun 2019 18:06:26 +0000 (UTC)
Received: from [10.3.118.11] (ovpn-118-11.phx2.redhat.com [10.3.118.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCE7A5C296;
        Mon,  3 Jun 2019 18:06:25 +0000 (UTC)
Subject: Re: ANNOUNCE: moving the ceph-devel list to ceph.io
To:     Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sweil@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
References: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal>
 <CAOi1vP8kUzBGw2L2XqdOhTM41zeyVxxHutHbSnhr4BG53aN-hQ@mail.gmail.com>
 <alpine.DEB.2.11.1906031641210.22596@piezo.novalocal>
 <CAOi1vP-jV8gD7DjkAHf05YAfTc549O1q7mxdVCVdXg=AnPYD1w@mail.gmail.com>
From:   Mark Nelson <mnelson@redhat.com>
Message-ID: <1402d595-3139-ba43-2503-f8e339d9c478@redhat.com>
Date:   Mon, 3 Jun 2019 13:06:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAOi1vP-jV8gD7DjkAHf05YAfTc549O1q7mxdVCVdXg=AnPYD1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 03 Jun 2019 18:06:26 +0000 (UTC)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/3/19 12:07 PM, Ilya Dryomov wrote:
> On Mon, Jun 3, 2019 at 6:45 PM Sage Weil <sweil@redhat.com> wrote:
>> On Mon, 3 Jun 2019, Ilya Dryomov wrote:
>>> On Mon, Jun 3, 2019 at 4:34 PM Sage Weil <sweil@redhat.com> wrote:
>>>> Why are we doing this?
>>>>
>>>> 1 The new list is mailman and managed by the Ceph community, which means
>>>>    that when people have problems with subscribe, mails being lost, or any
>>>>    other list-related problems, we can actually do something about it.
>>>>    Currently we have no real ability to perform any management-related tasks
>>>>    on the vger list.
>>>>
>>>> 2 The vger majordomo software also has some frustrating
>>>>    features/limitations, the most notable being that it only accepts
>>>>    plaintext email; anything with MIME or HTML formatting is rejected.  This
>>>>    confuses many users.
>>>>
>>>> 3 The kernel development and general Ceph development have slightly
>>>>    different modes of collaboration.  Kernel code review is based on email
>>>>    patches to the list and reviewing via email, which can be noisy and
>>>>    verbose for those not involved in kernel development.  The Ceph userspace
>>>>    code is handled via github pull requests, which capture both proposed
>>>>    changes and code review.
>>> I agree on all three points, although at least my recollection is that
>>> we have had a lot of bouncing issues with ceph-users and no issues with
>>> ceph-devel besides the plain text-only policy which some might argue is
>>> actually a good thing ;)
>>>
>>> However it seems that two mailing lists with identical names might
>>> bring new confusion, particularly when searching through past threads.
>>> Was a different name considered for the new list?
>> Sigh... we didn't discuss another name, and the confusion with
>> searching archives in particular didn't occur to me.  :(  If we're going
>> to use a different name, now is the time to pick one.
>>
>> I'm not sure what is better than ceph-devel, though...
> Perhaps just ceph@ceph.io?  Make it clear in the description that
> it is a development list and direct users to ceph-users@ceph.io.


Not perfect, but how about ceph-devel2?


Mark


>
>> Maybe making a new ceph-kernel@vger.kernel.org and aliasing the old
>> ceph-devel to either ceph-kernel or the (new) ceph-devel would be the
>> least confusing end state?
> I think the old list has to stay intact (i.e. continue as ceph-devel)
> for archive's sake.  vger doesn't provide a unified archive service so
> it's hard as it is...
>
> Thanks,
>
>                  Ilya
