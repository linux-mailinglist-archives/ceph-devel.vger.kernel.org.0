Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8EB304201
	for <lists+ceph-devel@lfdr.de>; Tue, 26 Jan 2021 16:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406173AbhAZPPS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 26 Jan 2021 10:15:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406052AbhAZPAU (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 26 Jan 2021 10:00:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4594230FC;
        Tue, 26 Jan 2021 14:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611673178;
        bh=DFK1JVWuWOOihCs30xjAM6Q8u5DzlY3msHx0YWofQVc=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=mqQnA9ugdsz/C5k1OSbmXKMRWy6abdRZUzeU7WZWIaifeB+CYy38NHSlYLpkPmRSa
         dlC91AWutpikvkfRr20C4XxTJjglVZe7LHYJ8y5x5/mC9IWTQ9UuJ9PpPoi4SEwMow
         cHNIpPZQj3OhHcvCkujn7/l2GM6I0rwUSZd662ixOLRoJDN+/hNrUEG8ov8r5vhBZb
         QG23KivulnyqFkgig4fLQ/sPvcKyN+s8ihHAUt98fNzwQf1Csq3iuGUXDAyP50odBY
         VJizHxeHD+70Kc/TEKRd16WNhxndvb3IMkLPTOO610CpHyGO5RdSItF0h5FeQSKnPm
         ArwUIHV0mfvPA==
Message-ID: <e9450c09a2484d1bd5e5c99e153d525c4b4b6453.camel@kernel.org>
Subject: Re: [PATCH] libceph: remove osdtimeout option entirely
From:   Jeff Layton <jlayton@kernel.org>
To:     Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Date:   Tue, 26 Jan 2021 09:59:36 -0500
In-Reply-To: <20210125173644.10220-1-idryomov@gmail.com>
References: <20210125173644.10220-1-idryomov@gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-01-25 at 18:36 +0100, Ilya Dryomov wrote:
> Commit 83aff95eb9d6 ("libceph: remove 'osdtimeout' option") deprecated
> osdtimeout over 8 years ago, but it is still recognized.  Let's remove
> it entirely.
> 
> Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> ---
>  net/ceph/ceph_common.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index bec181181d41..97d6ea763e32 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -252,7 +252,6 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
>   * ceph options
>   */
>  enum {
> -	Opt_osdtimeout,
>  	Opt_osdkeepalivetimeout,
>  	Opt_mount_timeout,
>  	Opt_osd_idle_ttl,
> @@ -320,8 +319,6 @@ static const struct fs_parameter_spec ceph_parameters[] = {
>  	fsparam_u32	("osd_idle_ttl",		Opt_osd_idle_ttl),
>  	fsparam_u32	("osd_request_timeout",		Opt_osd_request_timeout),
>  	fsparam_u32	("osdkeepalive",		Opt_osdkeepalivetimeout),
> -	__fsparam	(fs_param_is_s32, "osdtimeout", Opt_osdtimeout,
> -			 fs_param_deprecated, NULL),
>  	fsparam_enum	("read_from_replica",		Opt_read_from_replica,
>  			 ceph_param_read_from_replica),
>  	fsparam_enum	("ms_mode",			Opt_ms_mode,
> @@ -553,9 +550,6 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>  		}
>  		break;
>  
> 
> -	case Opt_osdtimeout:
> -		warn_plog(&log, "Ignoring osdtimeout");
> -		break;
>  	case Opt_osdkeepalivetimeout:
>  		/* 0 isn't well defined right now, reject it */
>  		if (result.uint_32 < 1 || result.uint_32 > INT_MAX / 1000)

Reviewed-by: Jeff Layton <jlayton@kernel.org>

