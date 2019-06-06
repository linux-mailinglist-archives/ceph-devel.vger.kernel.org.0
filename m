Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2C936D40
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Jun 2019 09:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbfFFHX1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Thu, 6 Jun 2019 03:23:27 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:46565 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbfFFHX1 (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Thu, 6 Jun 2019 03:23:27 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Thu, 06 Jun 2019 09:23:26 +0200
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.202])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Thu, 06 Jun 2019 08:22:59 +0100
Date:   Thu, 6 Jun 2019 09:22:58 +0200
From:   Jan Fajerski <jfajerski@suse.com>
To:     Patrick Donnelly <pdonnell@redhat.com>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>,
        Ramana Venkatesh Raja <rraja@redhat.com>
Subject: Re: luminous ceph_volume_client against a nautilus cluster
Message-ID: <20190606072258.77x6tq6lbe6iyani@jfsuselaptop>
Mail-Followup-To: Patrick Donnelly <pdonnell@redhat.com>,
        ceph-devel <ceph-devel@vger.kernel.org>,
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
http://tracker.ceph.com/issues/40182
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
