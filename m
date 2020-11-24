Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0890F2C26F3
	for <lists+ceph-devel@lfdr.de>; Tue, 24 Nov 2020 14:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387957AbgKXNPo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 24 Nov 2020 08:15:44 -0500
Received: from mx2.suse.de ([195.135.220.15]:39956 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387656AbgKXNPn (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 24 Nov 2020 08:15:43 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 122C2AC2D;
        Tue, 24 Nov 2020 13:15:42 +0000 (UTC)
Received: from localhost (brahms [local])
        by brahms (OpenSMTPD) with ESMTPA id d47154b7;
        Tue, 24 Nov 2020 13:15:57 +0000 (UTC)
From:   Luis Henriques <lhenriques@suse.de>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ceph: add ceph.caps vxattr
References: <a12a732b67245cc02344405f7dd9fef4f3b47fbc.camel@kernel.org>
        <20201123173846.15045-1-lhenriques@suse.de>
        <890e73cac81113e5958a39789fa119b7437bb191.camel@kernel.org>
Date:   Tue, 24 Nov 2020 13:15:57 +0000
In-Reply-To: <890e73cac81113e5958a39789fa119b7437bb191.camel@kernel.org> (Jeff
        Layton's message of "Tue, 24 Nov 2020 08:09:12 -0500")
Message-ID: <87v9durj3m.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Mon, 2020-11-23 at 17:38 +0000, Luis Henriques wrote:
>> Add a new vxattr that allows userspace to list the caps for a specific
>> directory or file.
>> 
>> Signed-off-by: Luis Henriques <lhenriques@suse.de>
>> ---
>> Hi!
>> 
>> Here's a version that also shows the caps in hexadecimal format, as
>> suggested by Jeff.  IMO the parenthesis and the '0x' prefix help the
>> readability, but they may make it a bit harder for scripts to parsing the
>> output.  I'm OK dropping those.
>> 
>> Cheers,
>
> Looks good, merged into "testing".

Awesome, thanks!

> I did make a slight change to the format -- instead of putting the hex
> value in parenthesis, I separated the two fields with a /, which I think
> should make things easier for scripts to parse.
>
> You should be able to do something like this to get at the hex value for
> testing:
>
>     $ getfattr -n ceph.caps foo | cut -d / -f2
>
> Let me know if you see issues with that and we can revisit the format.

Sure, I'm OK with that.  Or even simply dropping any separator, having
only a space/tab between the string and the hex value.

Another option I saw was to have two vxattrs: ceph.caps.string and
ceph.caps.int.  But that's probably overkill.

Cheers,
-- 
Luis
