Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6EC32CD1
	for <lists+ceph-devel@lfdr.de>; Mon,  3 Jun 2019 11:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfFCJ0G convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 3 Jun 2019 05:26:06 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:40621 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727557AbfFCJ0G (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Mon, 3 Jun 2019 05:26:06 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Mon, 03 Jun 2019 11:26:04 +0200
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.201])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Mon, 03 Jun 2019 10:26:01 +0100
Date:   Mon, 3 Jun 2019 11:26:00 +0200
From:   Jan Fajerski <jfajerski@suse.com>
To:     ceph-devel <ceph-devel@vger.kernel.org>
Subject: luminous ceph_volume_client against a nautilus cluster
Message-ID: <20190603092600.covgtxixlsgmw3mt@jfsuselaptop>
Mail-Followup-To: ceph-devel <ceph-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi,
I've asked about this in IRC already, but due to timezone foo ceph-devel might 
be more effective.
I was wondering if there was a plan or expectation of creating cephfs subvolumes 
using a luminous ceph_volume_client on a nautilus cluster (or any other sensible 
version combination)?
Currently this does not work, due to the volume client using the now removed 
'ceph mds dump' command. The fix is straight forward, but depending on if that 
should work this could be more complex (essentially making ceph_volume_client 
aware of the version of the ceph cluster).
I'm aware of the current refactor of the volume client as a mgr module. Will we 
backport this to luminous? Or is there an expectation that the volume client and 
the ceph cluster have to run the same version?

Best,
Jan

-- 
Jan Fajerski
Engineer Enterprise Storage
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
