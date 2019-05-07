Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBAAC165C1
	for <lists+ceph-devel@lfdr.de>; Tue,  7 May 2019 16:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfEGOfI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Tue, 7 May 2019 10:35:08 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:58542 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbfEGOfI (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Tue, 7 May 2019 10:35:08 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Tue, 07 May 2019 16:35:06 +0200
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.201])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Tue, 07 May 2019 15:34:35 +0100
Date:   Tue, 7 May 2019 16:34:33 +0200
From:   Jan Fajerski <jfajerski@suse.com>
To:     "Development, Ceph" <ceph-devel@vger.kernel.org>
Subject: Re: ceph-volume and multi-PV Volume groups
Message-ID: <20190507143433.wpq4tu3ltfvx35xl@jfsuselaptop>
Mail-Followup-To: "Development, Ceph" <ceph-devel@vger.kernel.org>
References: <20190429150725.4b3sijovqn5hi4ik@jfsuselaptop>
 <CAEPMp+6-h32Rgz9TskHj7dXDESorZo8O3HQDKHWhJfGWQgoS7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAEPMp+6-h32Rgz9TskHj7dXDESorZo8O3HQDKHWhJfGWQgoS7A@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, May 01, 2019 at 11:06:37AM -0500, Andrew Schoen wrote:
>> I'm aware that one could work around this by creating the LVM setup that I want.
>> I think this is a bad approach though since every deployment tool has to
>> implement its own LVM handling code. Imho the right place for this is exactly
>> ceph-volume.
>
>I've been thinking about porting some of the `batch` lv creation functionality
>to the `create` subcommand. I think it'd be nice to be able to pass a
>raw device to any of the
>available flags in `create` and if that device has already been used
>as a pv and a vg exists then
>that vg would be reused, otherwise a new pv and/or vg would be
>created. This is beneficial because it
>gives the control that users seem to wish `batch` had, like `create`
>already does. Would that solve this problem for you?
I think there's a lot merit to this approach! This could also neatly solve some 
other warty situations, e.g. when batch can create wal/db LVs but not the 
respective block LVs there situations where a rollback is not (easily) possible.  
That leaves behind some unused LVs but no OSDs.
>
>I'd be hesitant to change `batch` here. Originally we went down the
>path of having one vg per pv for
>db/wal but it added tons of complexity to the code to manage that.
>With fairly simple workarounds existing for
>`batch` plus the availability of the `create` subcommand we felt it
>wasn't worth the potential maintenance and
>complexity burden to put this sort of functionality in `batch`.
>
>Best,
>Andrew
>

-- 
Jan Fajerski
Engineer Enterprise Storage
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
