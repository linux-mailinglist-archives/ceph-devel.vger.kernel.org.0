Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88320338A7
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 20:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfFCS5N convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 3 Jun 2019 14:57:13 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:39887 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726653AbfFCS5L (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Mon, 3 Jun 2019 14:57:11 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Mon, 03 Jun 2019 20:57:09 +0200
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.201])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Mon, 03 Jun 2019 19:56:55 +0100
Date:   Mon, 3 Jun 2019 20:56:53 +0200
From:   Jan Fajerski <jfajerski@suse.com>
To:     Ceph Development <ceph-devel@vger.kernel.org>
Subject: Re: ANNOUNCE: moving the ceph-devel list to ceph.io
Message-ID: <20190603185653.2joftxdg7o4ebgqd@jfsuselaptop>
Mail-Followup-To: Ceph Development <ceph-devel@vger.kernel.org>
References: <alpine.DEB.2.11.1906022104460.3107@piezo.novalocal>
 <CAOi1vP8kUzBGw2L2XqdOhTM41zeyVxxHutHbSnhr4BG53aN-hQ@mail.gmail.com>
 <alpine.DEB.2.11.1906031641210.22596@piezo.novalocal>
 <CAOi1vP-jV8gD7DjkAHf05YAfTc549O1q7mxdVCVdXg=AnPYD1w@mail.gmail.com>
 <1402d595-3139-ba43-2503-f8e339d9c478@redhat.com>
 <CAJ4mKGYepinQ8_83MJrVh-rJubPKcmVwfy9vOqoyYEKsOUw61w@mail.gmail.com>
 <CA+aFP1Au9FnF35Wfv_nnLipgp2zWe_z5APSLPzm924xRJbd-6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+aFP1Au9FnF35Wfv_nnLipgp2zWe_z5APSLPzm924xRJbd-6A@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 03, 2019 at 02:46:43PM -0400, Jason Dillaman wrote:
>On Mon, Jun 3, 2019 at 2:45 PM Gregory Farnum <gfarnum@redhat.com> wrote:
>>
>> ceph-dev@ceph.io
>> ceph-develop@ceph.io
>> dev@ceph.io (doesn't confuse autocomplete)
>
>+1 to dev@ceph.io or devel@ceph.io since the ceph.io DNS name provides
>the context that it's for Ceph-related matters.
+1 one of the two.
>
>>
>> On Mon, Jun 3, 2019 at 11:07 AM Mark Nelson <mnelson@redhat.com> wrote:
>> >
>> >
>> > On 6/3/19 12:07 PM, Ilya Dryomov wrote:
>> > > On Mon, Jun 3, 2019 at 6:45 PM Sage Weil <sweil@redhat.com> wrote:
>> > >> On Mon, 3 Jun 2019, Ilya Dryomov wrote:
>> > >>> On Mon, Jun 3, 2019 at 4:34 PM Sage Weil <sweil@redhat.com> wrote:
>> > >>>> Why are we doing this?
>> > >>>>
>> > >>>> 1 The new list is mailman and managed by the Ceph community, which means
>> > >>>>    that when people have problems with subscribe, mails being lost, or any
>> > >>>>    other list-related problems, we can actually do something about it.
>> > >>>>    Currently we have no real ability to perform any management-related tasks
>> > >>>>    on the vger list.
>> > >>>>
>> > >>>> 2 The vger majordomo software also has some frustrating
>> > >>>>    features/limitations, the most notable being that it only accepts
>> > >>>>    plaintext email; anything with MIME or HTML formatting is rejected.  This
>> > >>>>    confuses many users.
>> > >>>>
>> > >>>> 3 The kernel development and general Ceph development have slightly
>> > >>>>    different modes of collaboration.  Kernel code review is based on email
>> > >>>>    patches to the list and reviewing via email, which can be noisy and
>> > >>>>    verbose for those not involved in kernel development.  The Ceph userspace
>> > >>>>    code is handled via github pull requests, which capture both proposed
>> > >>>>    changes and code review.
>> > >>> I agree on all three points, although at least my recollection is that
>> > >>> we have had a lot of bouncing issues with ceph-users and no issues with
>> > >>> ceph-devel besides the plain text-only policy which some might argue is
>> > >>> actually a good thing ;)
>> > >>>
>> > >>> However it seems that two mailing lists with identical names might
>> > >>> bring new confusion, particularly when searching through past threads.
>> > >>> Was a different name considered for the new list?
>> > >> Sigh... we didn't discuss another name, and the confusion with
>> > >> searching archives in particular didn't occur to me.  :(  If we're going
>> > >> to use a different name, now is the time to pick one.
>> > >>
>> > >> I'm not sure what is better than ceph-devel, though...
>> > > Perhaps just ceph@ceph.io?  Make it clear in the description that
>> > > it is a development list and direct users to ceph-users@ceph.io.
>> >
>> >
>> > Not perfect, but how about ceph-devel2?
>> >
>> >
>> > Mark
>> >
>> >
>> > >
>> > >> Maybe making a new ceph-kernel@vger.kernel.org and aliasing the old
>> > >> ceph-devel to either ceph-kernel or the (new) ceph-devel would be the
>> > >> least confusing end state?
>> > > I think the old list has to stay intact (i.e. continue as ceph-devel)
>> > > for archive's sake.  vger doesn't provide a unified archive service so
>> > > it's hard as it is...
>> > >
>> > > Thanks,
>> > >
>> > >                  Ilya
>
>
>
>-- 
>Jason
>

-- 
Jan Fajerski
Engineer Enterprise Storage
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
