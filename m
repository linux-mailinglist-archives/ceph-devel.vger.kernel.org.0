Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F29A1322FF
	for <lists+ceph-devel@lfdr.de>; Sun,  2 Jun 2019 12:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfFBK2C convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Sun, 2 Jun 2019 06:28:02 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:40173 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726229AbfFBK2C (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Sun, 2 Jun 2019 06:28:02 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Sun, 02 Jun 2019 12:28:00 +0200
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.201])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Sun, 02 Jun 2019 11:27:57 +0100
Date:   Sun, 2 Jun 2019 12:27:44 +0200
From:   Jan Fajerski <jfajerski@suse.com>
To:     ceph-devel@vger.kernel.org
Subject: Re: cephfs snapshot mirroring
Message-ID: <20190602102744.i4snecx7roum6kv7@jfsuselaptop>
Mail-Followup-To: ceph-devel@vger.kernel.org
References: <alpine.DEB.2.11.1905302154350.29593@piezo.novalocal>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.DEB.2.11.1905302154350.29593@piezo.novalocal>
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, May 30, 2019 at 09:56:25PM +0000, Sage Weil wrote:
>This is on the agenda for CDM next week, but I wrote up some notes here:
>
>	https://pad.ceph.com/p/cephfs-snap-mirroring
>
>It encompasses a few things besides just mirroring, starting with a set of
>comamnds to set up cephfs snapshot schedules and retention/rotation
>policy, which we need anyway, and seems related and like something we
>should add before doing mirroring.
>
>Thoughts?
Yay! I actually wanted to start on this this summer, so a) glad it's on the 
agenda and b) I'd be more then happy to work on it.

I left some comments in the etherpad. Generally I think it makes sense to 
separate the snapshot scheduling (and the accompanying pruning) and the 
mirroring. These two features are not really interdependent bur rather (can) 
work in concert. And some user might want to mirror their manual snapshots or 
not mirror at all.

Looking forward to Wednesday!

Jan
>
>sage
>

-- 
Jan Fajerski
Engineer Enterprise Storage
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
