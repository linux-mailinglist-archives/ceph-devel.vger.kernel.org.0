Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4F6E5C7
	for <lists+ceph-devel@lfdr.de>; Mon, 29 Apr 2019 17:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbfD2PHx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+ceph-devel@lfdr.de>); Mon, 29 Apr 2019 11:07:53 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:56262 "EHLO
        smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbfD2PHw (ORCPT
        <rfc822;groupwise-ceph-devel@vger.kernel.org:0:0>);
        Mon, 29 Apr 2019 11:07:52 -0400
Received: from emea4-mta.ukb.novell.com ([10.120.13.87])
        by smtp.nue.novell.com with ESMTP (TLS encrypted); Mon, 29 Apr 2019 17:07:51 +0200
Received: from localhost (nwb-a10-snat.microfocus.com [10.120.13.202])
        by emea4-mta.ukb.novell.com with ESMTP (TLS encrypted); Mon, 29 Apr 2019 16:07:26 +0100
Date:   Mon, 29 Apr 2019 17:07:25 +0200
From:   Jan Fajerski <jfajerski@suse.com>
To:     ceph-devel@vger.kernel.org
Subject: ceph-volume and multi-PV Volume groups
Message-ID: <20190429150725.4b3sijovqn5hi4ik@jfsuselaptop>
Mail-Followup-To: ceph-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: NeoMutt/20180716
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi all,
I'd like to request feedback regarding http://tracker.ceph.com/issues/37502.  
This regards the ceph-volume lvm batch subcommand and its handling of mulit-PV 
Volume Groups. The details are in the tracker ticket, the gist is that in 
certain circumstances ceph-volume creates LVM setups where a single bad drive 
that is used for db/wal can bring down unrelated OSDs (OSDs that have their LVs 
on completely separate drives) and thus impact a cluster fault tolerance.

I'm aware that one could work around this by creating the LVM setup that I want.  
I think this is a bad approach though since every deployment tool has to 
implement its own LVM handling code. Imho the right place for this is exactly 
ceph-volume.

Jan

-- 
Jan Fajerski
Engineer Enterprise Storage
SUSE Linux GmbH, GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
