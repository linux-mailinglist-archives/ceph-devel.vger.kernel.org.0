Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D82136C86
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 08:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726551AbfFFGr5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 6 Jun 2019 02:47:57 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:37078 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfFFGr4 (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Thu, 6 Jun 2019 02:47:56 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Thu, 06 Jun 2019 08:47:55 +0200
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.202])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Thu, 06 Jun 2019 07:47:48 +0100
Date:   Thu, 6 Jun 2019 08:47:47 +0200
From:   Jan Fajerski <jfajerski@suse.com>
To:     ceph-devel <ceph-devel@vger.kernel.org>
Cc:     Patrick Donnelly <pdonnell@redhat.com>,
        Ramana Venkatesh Raja <rraja@redhat.com>
Subject: Re: luminous ceph_volume_client against a nautilus cluster
Message-ID: <20190606064747.qnh73tymregwqjff@jfsuselaptop>
Mail-Followup-To: ceph-devel <ceph-devel@vger.kernel.org>,
        Patrick Donnelly <pdonnell@redhat.com>,
        Ramana Venkatesh Raja <rraja@redhat.com>
References: <20190603092600.covgtxixlsgmw3mt@jfsuselaptop>
 <CA+2bHPZ0jkoNWPBKcAWWe0=k8jwxUURPpOVaKKx0GZdo7rYC2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+2bHPZ0jkoNWPBKcAWWe0=k8jwxUURPpOVaKKx0GZdo7rYC2Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Jun 05, 2019 at 02:16:43PM -0700, Patrick Donnelly wrote:
>Hello Jan,
>
>On Mon, Jun 3, 2019 at 2:26 AM Jan Fajerski <jfajerski@suse.com> wrote:
>> I've asked about this in IRC already, but due to timezone foo ceph-devel might
>> be more effective.
>> I was wondering if there was a plan or expectation of creating cephfs subvolumes
>> using a luminous ceph_volume_client on a nautilus cluster (or any other sensible
>> version combination)?
>
>I do not think so. We do plan to have Nautilus clusters continue to
>function with the old ceph_volume_client.py clients.
>
>> Currently this does not work, due to the volume client using the now removed
>> 'ceph mds dump' command. The fix is straight forward, but depending on if that
>> should work this could be more complex (essentially making ceph_volume_client
>> aware of the version of the ceph cluster).
>
>... so this is a bug. Is there a tracker ticket open for this yet?

Not yet, will open one.
>
>> I'm aware of the current refactor of the volume client as a mgr module. Will we
>> backport this to luminous?
>
>No.
>
>>Or is there an expectation that the volume client and
>> the ceph cluster have to run the same version?
>
>That's what we'd like yes. I think the tricky part is dealing with
>applications (like Manila) using an older ceph_volume_client.py. We
>could backport a switch in the library so that it uses the new `ceph
>fs volume` commands if the cluster is Nautilus+. I'm not sure that is
>really needed though.

We see a case like that (luminous manila client against a nautilus cluster), so 
I'd argue something is needed. I have a patch for this (with a switch), though 
it might be enough to simply use 'ceph fs dump' instead of 'ceph mds dump' (i.e.  
without a switch). luminous has the fs command already after all. I'm just not 
sure if that would break something else.
>
>-- 
>Patrick Donnelly, Ph.D.
>He / Him / His
>Senior Software Engineer
>Red Hat Sunnyvale, CA
>GPG: 19F28A586F808C2402351B93C3301A3E258DD79D
>

-- 
Jan Fajerski
Engineer Enterprise Storage
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
